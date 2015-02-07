
# lib/omnibox-view
        
{View}  = require 'atom-space-pen-views'
SubAtom = require 'sub-atom'

module.exports =
class OmniboxView extends View
  
  @content: ->
    @div class:'omnibox', tabindex:-1, =>
      @input 
        outlet: 'input'
        placeholder: 'Web-Browser: Enter URL or search query'
        class: 'native-key-bindings'

  initialize: (@browser) ->
    @subs = new SubAtom
    @setEvents()
  
  focus: -> @input.focus()
  onFocusChg: (@focusCallback) ->
    
  setURL: (url) -> @input.val url.replace /\/$/, ''

  setEvents: ->
    @subs.add @input, 'keydown', (e) =>
      switch e.which
        when 13 # cr
          url = @input.val().replace /\/$/, ''
          if not /[\.]/.test(url) or /\s/.test(url)
            url = 'https://www.google.com/search?q=' + encodeURI url
          else
            if not /^\w+:\/\//.test url then url = 'http://' + url
          if e.ctrlKey then @browser.createPage         url; @input.blur()
          else              @browser.setUrlOrCreatePage url; @input.blur()
        when  9 then @input.blur()          # tab
        when 27 then @browser.hideToolbar() # esc           
        else return
      false

    @subs.add @input, 'changed', (e) => @browser.omniboxTextChanged()
      
    # var @focused is used in pageView for speed
    @subs.add @input, 'focus', =>
      @focused = yes
      @focusCallback? yes
          
    @subs.add @input, 'blur', =>
      @focused = no
      @focusCallback? no

  destroy: ->
    @subs.dispose()
    @detach()
