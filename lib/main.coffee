
# lib/main

Browser = require './browser'

module.exports =
  activate: -> 
    atom.workspaceView.command "browser:open", =>
      atom.workspace.activePane.activateItem new Browser "I'm Alive!"

