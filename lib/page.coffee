
# lib/page

{Emitter} = require 'emissary'
PageView  = require './page-view'
History   = require './history'
urlUtil   = require 'url'

module.exports =
class Page
  Emitter.includeInto @

  constructor: (@browser, @url) -> @history = new History @url
    
  getLongTitle:    -> urlUtil.parse(@url).host
  calcTitle: (url) -> @title = urlUtil.parse(url).host
  
  back:    -> @pageView.setLocation @history.back()
  forward: -> @pageView.setLocation @history.forward()
  refresh: -> @pageView.setLocation @url
  
  setLocation: (@url) -> @pageView.setLocation @url
  
  locationChanged: (@url) -> 
    @browser.setOmniText @url
    @history.locationChanged @url
  
  setView:    (@pageView) ->
  getBrowser:             -> @browser
  getClass:               -> Page
  getViewClass:           -> PageView
  getView:                -> @pageView
  getTitle:               -> @title
  getHistory:             -> @history
  getLocation:            -> @url
  
  

  