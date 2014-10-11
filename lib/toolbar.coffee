
# lib/toolbar

ToolbarView = require './toolbar-view'

module.exports =
class Toolbar
  
  constructor: (browser) ->
    @toolbarView = new ToolbarView browser
    
  getView: -> @toolbarView
  
  getOmniboxView: -> @toolbarView.getOmniboxView()
  
  setOmniText: (text) -> @toolbarView.setOmniText text

  destroy: ->
    @toolbarView.destroy?()
