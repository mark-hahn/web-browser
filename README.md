# web-browser package

A web browser that runs seamlessly in the Atom editor

![Animated GIF](https://github.com/mark-hahn/web-browser/blob/master/screenshots/browser.gif?raw=true)

This is a web browser tightly integrated into the Atom editor.  The web pages appear in the normal editor tabs.  The pages are fully functional with scripting and linking. A browser toolbar appears at the top of the Atom window to allow simple webpage navigation.

The browser is quite useful for testing a web page inside the same programming editor being used for development.  Splitting panes allow code to be seen next to the web page.

The browser has a simple API for other Atom packages to use.  @kgrossjo on the Atom discussion board suggested a package that allows clicking on a word in source code and showing the web page documention for the word.

## Usage
  
- Install with `apm install web-browser`
- Press `ctrl-alt-B` (`web-browser:toggle`) and a toolbar will appear above the tabs
- Enter a url and press enter
- To later create a new tab use ctrl-enter instead
- Press `ctrl-alt-B` again to refocus input
- Press `ctrl-alt-B` again to close the toolbar
- Click on the globe in the toolbar to close the toolbar (secret feature)

### Favorites

The package `command-toolbar` supports buttons to save webpages and open them at any time with a single click.  This means that it can act as a "favorites" toolbar for this web-browser package.

## API

This web-browser package listens for requests to open URLs.  This is anything that starts with `http://` or `https://`.  To open a webpage from code use the `atom.workspace.open` command with such a URL.
  
## License

Copyright Mark Hahn by MIT license
