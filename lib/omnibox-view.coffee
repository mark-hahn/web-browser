
# lib/omnibox-view
        
{View} = require 'atom'

module.exports =
class OmniboxView extends View
  
  @content: ->
    @div class:'omnibox', tabindex:-1, =>
      @input 
        outlet: 'input'
        placeholder: 'Atom Browser: Enter URL'
        class: 'native-key-bindings'

  initialize: (omnibox) ->
    @input.val 'http://apple.com'
    
    @subscribe @input, 'keypress', (e) =>
      switch e.which
        when 13 then omnibox.openPage @input.val()
        when 27, 9 
          @input.blur()
          return false
        
  focused: -> @input.is ':focus'
  
  focus: (cb) -> @subscribe @input, 'focus', =>
    @input.css backgroundColor: 'white'
    cb()
    
  blur:  (cb) -> @subscribe @input, 'blur', =>
    @input.css backgroundColor: 'transparent'
    cb()
    
  setURL: (url) -> @input.val url

  destroy: ->
    @unsubscribe()
    @detach()
