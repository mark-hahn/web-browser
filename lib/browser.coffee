
# lib/browser

{Emitter}   = require 'emissary'
BrowserView = require './browser-view'

module.exports =
class Browser
  
  # This may appear to not be used but the tab opener code requires it
  Emitter.includeInto @
  
  constructor: (@tabTitle) ->
  
  getTitle:     -> @tabTitle
  getViewClass: -> BrowserView
  
