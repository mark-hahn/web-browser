
# lib/browser-view

{View} = require 'atom'

module.exports =
class BrowserView extends View
  
  @content: ->
    @h1 "The browser package is Alive! It's ALIVE!"
