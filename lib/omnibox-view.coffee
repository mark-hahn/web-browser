
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
  
  focus:     -> @input.focus()
  isFocused: -> @input.is ':focus'
    
  setURL: (url) -> @input.val url.replace /\/$/, ''

  setEvents: ->
    @subs.add @input, 'keydown', (e) =>
      switch e.which
        when 13 # cr
          url = @input.val().replace /\/$/, ''
          if (not /^\w+:\/\// .test(url)  and
              not /^localhost/.test(url)) and
              (not /[\.]/.test(url) or /\s/.test(url))
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
      
  destroy: ->
    @subs.dispose()
    @detach()
