
# lib/web-browser

Toolbar = require './toolbar'
Page    = require './page'

class WebBrowser
  activate: ->
    atom.webBrowser = @ 
    atom.workspaceView.command "web-browser:toggle", =>
      switch
        when not @toolbar 
          @toolbar = new Toolbar @
          @toolbar.focus()
        when not @toolbar.focused()
          @toolbar.focus()
        else
          @destroyToolbar()
        
  getToolbar:                -> @toolbar
  getOmniboxView:            -> @toolbar?.getOmniboxView()
  setOmniText:        (text) -> @toolbar?.setOmniText text
  setFaviconDomain: (domain) -> @toolbar?.setFaviconDomain domain
  
  destroyToolbar: -> 
    @toolbar.destroy()
    @toolbar = null
    
  createPage: (url) ->
    @toolbar ?= new Toolbar @
    atom.workspace.activePane.activateItem new Page @, url
    
  setLocation: (url) ->
    @toolbar ?= new Toolbar @
    @toolbar.setOmniText url
    if (page = @getActivePage()) then page.setLocation url
    else @createPage url
      
  getActivePage: ->
    page = atom.workspace.getActivePaneItem()
    (if page instanceof Page then page)

  back:    -> if (page = @getActivePage()) then page.back()
  forward: -> if (page = @getActivePage()) then page.forward()
  refresh: -> if (page = @getActivePage()) then page.refresh()
    
module.exports = new WebBrowser
