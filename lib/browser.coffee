
# lib/browser

Toolbar = require './toolbar'
Page    = require './page'

module.exports =
  activate: -> 
    atom.workspaceView.command "browser:toggle", =>
      if not @toolbar
        @toolbar = new Toolbar @
      else
        @toolbar.destroy()
        @toolbar = null
        
  createPage: (url) ->
    atom.workspace.activePane.activateItem new Page @, url
    
  getPage: ->
    page = atom.workspace.getActivePaneItem()
    (if page instanceof Page then page)

  setLocation: (url) ->
    @toolbar.setOmniText url
    if not @chgFromButton
      if (page = @getPage())
      	page.setLocation url
      else
        @createPage url
      
  getOmniboxView: ->
    @toolbar.getOmniboxView()
    
  setOmniText: (text) -> 
    @toolbar.setOmniText text
    
  back: ->
    if (page = @getPage()) 
      @chgFromButton = yes
      page.back()
      @chgFromButton = no
      
  forward: ->
    if (page = @getPage())
      @chgFromButton = yes
      page.forward()
      @chgFromButton = no
  
  refresh: ->
    if (page = @getPage())
      @chgFromButton = yes
      page.refresh()
      @chgFromButton = no
    