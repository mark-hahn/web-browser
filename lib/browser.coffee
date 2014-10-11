
# lib/browser

Toolbar = require './toolbar'

module.exports =
  activate: -> 
    atom.workspaceView.command "browser:toggle", =>
      if not @toolbar
        @toolbar = new Toolbar
      else
        @toolbar.destroy()
        @toolbar = null
