
# lib/toolbar

ToolbarView = require './toolbar-view'

module.exports =
class Toolbar
  
  constructor: ->
    @toolbarView = new ToolbarView @
    
  getView: -> @toolbarView

  destroy: ->
    @toolbarView.destroy?()
