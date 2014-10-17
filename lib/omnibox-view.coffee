
# lib/omnibox-view
        
{View}  = require 'atom'

module.exports =
class OmniboxView extends View
  
  @content: ->
    @div class:'omnibox', tabindex:-1, =>
      @input 
        outlet: 'input'
        placeholder: 'Web-Browser: Enter URL'
        class: 'native-key-bindings'

  initialize: (browser) ->
    @subscribe @input, 'keydown', (e) =>
      url = @input.val()
      if not /^\w+:\/\//.test url then url = 'http://' + url
      switch e.which
        when 13 # cr
          if e.ctrlKey then browser.createPage  url; @input.blur()
          else              browser.setLocation url; @input.blur()
        when  9 then                                 @input.blur() # tab
        when 27 then        browser.getToolbar().destroy();        # esc           
        else return
      false
      
    # var @focused is used in pageView for speed
    @subscribe @input, 'focus', =>
      @focused = yes
      @focusCallback? yes
          
    @subscribe @input, 'blur', =>
      @focused = no
      @focusCallback? no
    
  focus: -> @input.focus()
  onFocusChg: (@focusCallback) ->
    
  setText: (text) -> @input.val text

  destroy: ->
    @unsubscribe()
    @detach()
