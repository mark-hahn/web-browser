
# lib/toolbar-view

{View}  = require 'atom'
Omnibox = require './omnibox'

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
        
  initialize: (toolbar) ->
    atom.workspaceView.prependToTop @
    @omniboxView = new Omnibox().getView()
    @omniboxContainer.append @omniboxView
    
    @omniboxView.focus => @navBtnsRgt.hide()
    @omniboxView.blur  => @navBtnsRgt.show()
    
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
