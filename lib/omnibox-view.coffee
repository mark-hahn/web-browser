
# lib/omnibox-view

{View} = require 'atom'

module.exports =
class OmniboxView extends View
  
  @content: ->
    @div class:'browser', tabindex:-1, =>
      @input 
        outlet: 'input'
        placeholder: 'Atom Browser: Enter URL'
        class: 'native-key-bindings omnibox-input'

  initialize: (omnibox) ->
    atom.workspaceView.prependToTop @
    
    @input.val 'http://apple.com'
    
    @subscribe @input, 'keypress', (e) =>
      switch e.which
        when 13 then omnibox.openPage @input.val()
        
    setTimeout (=> @focus()), 100
    
  focused: -> @input.is ':focus'
    
  setURL: (url) -> @input.val url

  destroy: ->
    @unsubscribe()
    @detach()
