
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

  initialize: (browser) ->
    @input.val 'http://apple.com'
    
    @subscribe @input, 'keypress', (e) =>
      switch e.which
        when 13 
          url = @input.val()
          if e.ctrlKey then browser.createPage  url
          else              browser.setLocation url
        when 27, 9 
          @input.blur()
          return false
          
  # @focused is used in pageView for speed
  focus: (cb) -> @subscribe @input, 'focus', =>
    @input.css backgroundColor: 'white'
    @focused = yes
    cb()
    
  blur:  (cb) -> @subscribe @input, 'blur', =>
    @input.css backgroundColor: 'transparent'
    @focused = no
    cb()
    
  setText: (text) -> @input.val text

  destroy: ->
    @unsubscribe()
    @detach()
