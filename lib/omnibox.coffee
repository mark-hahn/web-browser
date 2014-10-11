
# lib/omnibox

OmniboxView = require './omnibox-view'
Page        = require './page'

module.exports =
class Omnibox
  
  constructor: ->
    @omniboxView = new OmniboxView @
    
  openPage: (url) ->
    title = Page.calcTitle url
    atom.workspace.activePane.activateItem new Page @, title, url
    
  getView: -> @omniboxView

  destroy: ->
    @omniboxView.destroy()
