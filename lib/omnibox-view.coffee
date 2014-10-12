
# lib/omnibox-view
        
{View}  = require 'atom'

module.exports =
class OmniboxView extends View
  
  @content: ->
    @div class:'omnibox', tabindex:-1, =>
      @input 
        outlet: 'input'
        placeholder: 'Atom Browser: Enter URL'
        class: 'native-key-bindings'

  initialize: (browser) ->
    @input.val 'http://'
    
    @subscribe @input, 'keypress', (e) =>
      url = @input.val()
      switch e.which
        when 13 then browser.setLocation url; @input.blur(); return false
        when 10 then browser.createPage  url; @input.blur(); return false
                    
    # var @focused is used in pageView for speed
    @subscribe @input, 'focus', =>
      @input.css backgroundColor: 'white'
      @focused = yes
      @focusCallback? yes
          
    @subscribe @input, 'blur', =>
      @input.css backgroundColor: 'transparent'
      @focused = no
      @focusCallback? no
    
  focus: (@focusCallback) ->
    
  setText: (text) -> @input.val text

  destroy: ->
    @unsubscribe()
    @detach()
