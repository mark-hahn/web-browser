
# lib/main

Omnibox = require './omnibox'

module.exports =
  activate: -> 
    atom.workspaceView.command "browser:toggle", =>
      if not @omnibox
        @omnibox = new Omnibox
      else
        @omnibox.destroy()
        @omnibox = null
