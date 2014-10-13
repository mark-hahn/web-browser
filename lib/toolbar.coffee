
# lib/toolbar

ToolbarView = require './toolbar-view'

module.exports =
class Toolbar
  
  constructor: (browser) ->
    @toolbarView = new ToolbarView browser
    
  getView: -> @toolbarView
  
  focus:   -> @toolbarView.focus()
  focused: -> @toolbarView.focused()
  
  getOmniboxView:            -> @toolbarView.getOmniboxView()
  setOmniText:        (text) -> @toolbarView.setOmniText text
  setFaviconDomain: (domain) -> @toolbarView.setFaviconDomain domain

  destroy: ->
    @toolbarView.destroy?()
