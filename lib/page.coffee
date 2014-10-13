
# lib/page

{Emitter} = require 'emissary'
PageView  = require './page-view'
History   = require './history'
urlUtil   = require 'url'

module.exports =
class Page
  Emitter.includeInto @

  constructor: (@browser, @url) -> @history = new History @url

  setTitle: (@title) ->
  getTitle:     -> @title or urlUtil.parse(@url).host
  getLongTitle: -> @getTitle()
  
  back:    -> @pageView.setLocation @history.back()
  forward: -> @pageView.setLocation @history.forward()
  refresh: -> @pageView.setLocation @url
  
  setLocation: (@url) -> 
    @pageView.setLocation @url
  
  locationChanged: (@url) -> 
    @history.locationChanged @url
    @browser.setOmniText     @url
    faviconDomain = urlUtil.parse(@url).hostname
    @browser.setFaviconDomain  faviconDomain
    @pageView.setFaviconDomain faviconDomain
  
  setView: (@pageView) ->
  getBrowser:   -> @browser
  getClass:     -> Page
  getViewClass: -> PageView
  getView:      -> @pageView
  getPath:      -> @url
  