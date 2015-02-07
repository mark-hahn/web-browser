
# lib/page

PageView  = require './page-view'
urlUtil   = require 'url'

module.exports =
class Page
  constructor: (@browser, @url) ->

  setView: (@pageView) ->
  setTitle:   (@title) ->
  setURL:       (@url) -> @pageView.setURL url
  
  update:        -> @pageView.update()
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
