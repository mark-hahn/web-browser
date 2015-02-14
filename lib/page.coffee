
# lib/page

PageView  = require './page-view'
urlUtil   = require 'url'

module.exports =
class Page
  constructor: (@browser, @url) ->
    
  copy: -> 
    newPage = @browser.newPage @getPath()
    setTimeout @resizeBugFix.bind(newPage), 3000
    newPage
    
  setView:  (@pageView) ->
  setTitle: (@title) ->
  setURL:   (@url) -> @pageView.setURL url
  toggleDev:       -> @pageView.toggleDev()
  
  # fixes a bug that causes webview to go blank until it is resized
  # https://github.com/atom/atom-shell/issues/1110
  resizeBugFix: -> 
    @pageView.css width: 1, height: 1
    process.nextTick =>
      @pageView.css width: '100%', height: '100%'
  
  setLive: (@liveUrl) -> 
  didSaveText: -> 
    if @liveUrl then setTimeout =>
      @pageView.setURL @liveUrl, 'autoReload'
    , 1000 * atom.config.get 'web-browser.autoReloadDelay'
  
  update: -> @pageView.update()
  
  getTitle:      -> @title or urlUtil.parse(@url).host
  getLongTitle:  -> @getTitle()
  getBrowser:    -> @browser
  getClass:      -> Page
  getViewClass:  -> PageView
  getView:       -> @pageView
  getPath:       -> @url
  
  destroy: ->
    @browser.pageDestroyed @
    @pageView?.destroy()
