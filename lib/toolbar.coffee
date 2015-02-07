
# lib/toolbar

ToolbarView = require './toolbar-view'

module.exports =
class Toolbar
  
  constructor: (@browser) ->
    @toolbarView = new ToolbarView @browser
    
  getView:       -> @toolbarView
  setURL: (@url) -> @toolbarView.setURL url
      
  setNavControls: (controls) -> @toolbarView.setNavControls controls
  visible:                   -> @toolbarView.is ':visible'
  show:                      -> @toolbarView.show()
  hide:                      -> @toolbarView.hide()
  focus:                     -> @toolbarView.focus()
  focused:                   -> @toolbarView.focused()
      
  destroy: ->
    @toolbarView.destroy()
