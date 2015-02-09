
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
      if /^(https?|file):\/\//i.test filePath then @createPage filePath
        
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
      
  #### public ####

  createPage: (url) ->
    atom.workspace.getActivePane().activateItem @newPage url

  setUrlOrCreatePage: (url) ->
    url = url.replace /\/$/, ''
    if @visiblePage 
      @toolbar.setURL url
      @visiblePage.setURL url
    else 
      @createPage url
      
  #### private ####

  hideToolbar: -> @toolbar.hide()
  
  newPage: (url) ->
    @visiblePage = new @Page(@, url)
    @allPages.push @visiblePage
    @toolbar.setURL url
    @visiblePage

  setNavControls: (controls, fromPage) -> 
    if not fromPage or fromPage is @visiblePage
      @toolbar.setNavControls controls
      
  clearVisiblePage: ->
    # console.log 'clearVisiblePage', @visiblePage?.getView?()?.dbg
    @toolbar.setNavControls 
      goBack: null, goForward: null, reload: null, toggleLive: null, toggleDev: null
      canGoBack: no, canGoForward: no, pageShowing: no
    @visiblePage = null

  setEvents: ->
    
    @subs.add atom.workspace.onDidChangeActivePaneItem (item) =>
      # process.nextTick =>  this unfixes the fix
      if item instanceof @Page 
        if item isnt @visiblePage
          @visiblePage = item
          item.update()
          @toolbar.setURL item.getPath()
          @visiblePage.resizeBugFix()
      else
        @clearVisiblePage()
          
    atom.commands.add 'atom-workspace', 'core:save', => 
      for page in @allPages
        page?.didSaveText()
        
    atom.commands.add 'atom-workspace', 'web-browser:toggle-dev': =>
      @visiblePage?.toggleDev()
        
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
