
# lib/page

PageView  = require './page-view'
urlUtil   = require 'url'

module.exports =
class Page
  constructor: (@browser, @url) ->
    
  copy: -> @browser.newPage @getPath()

  setView:  (@pageView) ->
  setTitle: (@title) ->
  setURL:   (@url) -> @pageView.setURL url
  
  # fixes a bug that causes a webview to go blank until it is resized
  resizeBugFix: -> 
    # @pageView.css width: 1, height: 1
    # process.nextTick =>
    #   @pageView.css width: '100%', height: '100%'
  
  setLive: (@live) -> 
  didSaveText: -> 
    if @live then setTimeout =>
      @pageView.reload()
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
