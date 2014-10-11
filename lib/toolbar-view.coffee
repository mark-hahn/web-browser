
# lib/toolbar-view

{$, View}  = require 'atom'
OmniboxView = require './omnibox-view'

module.exports =
class ToolbarView extends View
  
  @content: ->
    @div class:'browser-toolbar', tabindex:-1, =>
      
      @div outlet: 'navBtnsLft', class:'nav-btns left', =>
        @span class:'octicon octicon-globe'
        @span class:'octicon browser-btn octicon-arrow-left'
        @span class:'octicon browser-btn octicon-arrow-right'
        @span class:'octicon browser-btn octicon-sync'
        
      @div outlet:'omniboxContainer', class:'omnibox-container'
      
      @div outlet: 'navBtnsRgt', class:'nav-btns right', =>
        @span class:'octicon browser-btn octicon-three-bars'
        
  initialize: (browser) ->
    atom.workspaceView.prependToTop @
    @omniboxView = new OmniboxView browser
    @omniboxContainer.append @omniboxView
    
    @omniboxView.focus => @navBtnsRgt.hide()
    @omniboxView.blur  => @navBtnsRgt.show()
    
    @subscribe @, 'click', (e) ->
      if (classes = $(e.target).attr 'class') and 
         (btnIdx  = classes.indexOf 'octicon-') > -1
        switch classes[btnIdx+8...]
          when 'arrow-left'  then browser.back()
          when 'arrow-right' then browser.forward()
          when 'sync'        then browser.refresh()
      
  getOmniboxView: -> @omniboxView
  
  setOmniText: (text) -> @omniboxView.setText text
    
  destroy: ->
    @detach()

###
  octicon-bookmark
  bug
  chevron-left
  chevron-right
  file-directory
  gear
  globe
  history
  pencil
  pin
  plus
  star
  heart
  sync
  x
###
