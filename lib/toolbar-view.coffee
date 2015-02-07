
# lib/toolbar-view

{$, View}   = require 'atom'
OmniboxView = require './omnibox-view'
SubAtom     = require 'sub-atom'

module.exports =
class ToolbarView extends View
  
  @content: ->
    @div class:'browser-toolbar', tabindex:-1, =>
      
      @div outlet: 'navBtnsLft', class:'nav-btns left', =>
        @span outlet: 'globeBtn',   class:'octicon octicon-globe'
        @span outlet: 'backBtn',    class:'octicon browser-btn octicon-arrow-left'
        @span outlet: 'fwdBtn',     class:'octicon browser-btn octicon-arrow-right'
        @span outlet: 'reloadBtn',  class:'octicon browser-btn octicon-sync'
      
      @div outlet:'omniboxContainer', class:'omnibox-container'
      
      @div outlet: 'navBtnsRgt', class:'nav-btns right', =>
        @span class:'octicon browser-btn octicon-three-bars'
        
  initialize: (@browser) ->
    @subs = new SubAtom
    atom.workspace.addTopPanel item: @
    @omniboxView = new OmniboxView @browser
    @omniboxContainer.append @omniboxView
    @setURL ''
    @setEvents()
    
  setNavControls: ({@goBack, @goForward, @reload, canGoBack, canGoForward, canReload}) -> 
    if canGoBack    then @backBtn  .removeClass 'disabled'
    else                 @backBtn  .addClass    'disabled'
    if canGoForward then @fwdBtn   .removeClass 'disabled'
    else                 @fwdBtn   .addClass    'disabled'
    if canReload    then @reloadBtn.removeClass 'disabled'
    else                 @reloadBtn.addClass    'disabled'
  
  focus:   -> @omniboxView.focus()
  focused: -> @isFocused

  getOmniboxView: -> @omniboxView
  setURL:  (@url) -> @omniboxView.setURL url
    
  setEvents: ->
    @omniboxView.onFocusChg (@isFocused) => 
      if @isFocused then @navBtnsRgt.hide() else @navBtnsRgt.show()
    
    @subs.add @, 'click', (e) =>
      if (classes = $(e.target).attr 'class') and 
         (btnIdx  = classes.indexOf 'octicon-') > -1
        switch classes[btnIdx+8...]
          when 'globe'       then @browser.hideToolbar()
          when 'arrow-left'  then @goBack?()
          when 'arrow-right' then @goForward?()
          when 'sync'        then @reload?()
          
  destroy: ->
    @subs.dispose()
    @detach()
