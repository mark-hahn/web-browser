
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
      
      @img outlet:'favicon', class:'favicon'
      @div outlet:'omniboxContainer', class:'omnibox-container'
      
      @div outlet: 'navBtnsRgt', class:'nav-btns right', =>
        @span class:'octicon browser-btn octicon-three-bars'
        
  initialize: (browser) ->
    atom.workspaceView.prependToTop @
    @omniboxView = new OmniboxView browser
    @omniboxContainer.append @omniboxView
    @setOmniText ''
    
    @omniboxView.onFocusChg (@isFocused) => 
      if @isFocused then @navBtnsRgt.hide() else @navBtnsRgt.show()
    
    @subscribe @, 'click', (e) ->
      if (classes = $(e.target).attr 'class') and 
         (btnIdx  = classes.indexOf 'octicon-') > -1
        switch classes[btnIdx+8...]
          when 'globe'       then browser.destroyToolbar()
          when 'arrow-left'  then browser.back()
          when 'arrow-right' then browser.forward()
          when 'sync'        then browser.refresh()
          
  focus:   -> @omniboxView.focus()
  focused: -> @isFocused

  getOmniboxView: -> @omniboxView
  setOmniText: (text) -> 
    @omniboxView.setText text
    if not text then @setFaviconDomain 'atom.io'
    
  setFaviconDomain: (domain) -> 
    @favicon.attr src: "http://www.google.com/s2/favicons?domain=#{domain}"
    
  destroy: ->
    @unsubscribe()
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
