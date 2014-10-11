
# lib/page

{Emitter} = require 'emissary'
PageView  = require './page-view'
History   = require './history'
urlUtil   = require 'url'

module.exports =
class Page
  Emitter.includeInto @

  @calcTitle = (url) -> 
    urlUtil.parse(url).pathname.replace /\//g, ' '
  
  constructor: (@browser, @url) -> 
    @history = new History @url
  
  setLocation: (@url) -> 
    @pageView.setLocation @url
    
  locationChanged: (@url) ->
    @history.locationChanged @url
    
  back:    -> @pageView.setLocation @history.back()
  forward: -> @pageView.setLocation @history.forward()
  refresh: -> @pageView.setLocation @url
  
  setView: (@pageView) ->
  
  getBrowser:   -> @browser
  getClass:     -> Page
  getViewClass: -> PageView
  getView:      -> @pageView
  getTitle:     -> @title
  getHistory:   -> @history
  getURL:       -> @url
  
  

  