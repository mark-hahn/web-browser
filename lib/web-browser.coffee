
# lib/web-browser

class WebBrowser
  config:
    autoReloadDelay:
      title: 'Delay in seconds before auto-reload'
      type: 'number'
      default: 1.0
      minimum: 0.0
      maximum: 5.0

  activate: ->
    atom.commands.add 'atom-workspace', 'web-browser:toggle': =>
      @delayedActivate()
      switch
        when not @toolbar.visible() then @toolbar.show().focus()
        when not @toolbar.focused() then @toolbar.focus()
        else @hideToolbar()

    @openerDisposable = atom.workspace.addOpener (filePath, options) =>
      @delayedActivate()
      if /https?:\/\//.test filePath then @createPage filePath
        
  delayedActivate: ->
    if not @isFullyActivated
      @isFullyActivated = yes
      @subs = new (require('sub-atom'))
      @subs.add @openerDisposable
      @toolbar = new (require('./toolbar'))(@)
      @clearVisiblePage()
      @hideToolbar()
      @Page = require './page'
      @allPages = []
      @setEvents()    
      
  hideToolbar: -> @toolbar.hide()
  
  setUrlOrCreatePage: (url) ->
    url = url.replace /\/$/, ''
    if @visiblePage 
      @toolbar.setURL url
      @visiblePage.setURL url
    else 
      @createPage url

  createPage: (url) ->
    url = url.replace /\/$/, ''
    @toolbar.setURL url
    @visiblePage = new @Page(@, url)
    @allPages.push @visiblePage
    atom.workspace.getActivePane().activateItem @visiblePage

  setNavControls: (controls, fromPage) -> 
    if not fromPage or fromPage is @visiblePage
      @toolbar.setNavControls controls
      
  clearVisiblePage: ->
    @toolbar.setNavControls 
      goBack: null, goForward: null, reload: null, toggleLive: null
      canGoBack: no, canGoForward: no, canReload: no, canToggleLive: no
    @visiblePage = null

  setEvents: ->
    @subs.add atom.workspace.onDidChangeActivePaneItem (item) =>
      if item instanceof @Page 
        if item isnt @visiblePage
          @visiblePage = item
          item.update()
          @toolbar.setURL item.getPath()
      else
        @clearVisiblePage()
    atom.commands.add 'atom-workspace', 'core:save', => 
      for page in @allPages
        page?.didSaveText()
        
  pageDestroyed: (pageIn) ->
    for page, idx in @allPages
      if page is pageIn 
        delete @allPages[idx]
        return
  
  deactivate: ->
    if @delayActivated
      @subs.dispose()
      @toolbar.destroy()
      page?.destroy() for page in @allPages
    
module.exports = new WebBrowser
