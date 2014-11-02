
# lib/web-browser

Toolbar = require './toolbar'
Page    = require './page'

class WebBrowser
  activate: ->
    atom.webBrowser = @ 
    atom.workspaceView.command "web-browser:toggle", =>
      @toolbar ?= new Toolbar @
      switch
        when not @toolbar.visible()
          @toolbar.show().focus()
        when not @toolbar.focused()
          @toolbar.focus()
        else
          @toolbar.hide()
          
    atom.workspace.onDidChangeActivePaneItem =>
      if @getActivePage() then @page.update()
      else if @page then @page.locationChanged @page.getPath()
      
    @opener = (filePath, options) =>
      if /^https?:\/\//.test filePath
        new Page @, filePath
        
    atom.workspace.registerOpener @opener
    
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
    if @getActivePage()?.setLocation url
    else @createPage url
      
  getActivePage: ->
    page = atom.workspace.getActivePaneItem()
    if page instanceof Page then @page = page; return @page

  back:    -> @getActivePage()?.back()
  forward: -> @getActivePage()?.forward()
  refresh: -> @getActivePage()?.refresh()
  
  deactivate: ->
    atom.workspace.unregisterOpener @opener
    
module.exports = new WebBrowser
