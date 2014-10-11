
# lib/page

# An instance of Page is sent to the active pane for opening

{Emitter} = require 'emissary'
PageView  = require './page-view'
urlUtil   = require 'url'

module.exports =
class Page
  @calcTitle = (url) -> 
    urlUtil.parse(url).pathname.replace /\//g, ' '
  
  # This may appear to not be used but the active pane code requires it
  Emitter.includeInto @
  
  constructor: (@omnibox, @title, @url) ->
  
  getClass:     -> Page
  getViewClass: -> PageView
  getOmnibox:   -> @omnibox
  getTitle:     -> @title
  getURL:       -> @url
  
  

  