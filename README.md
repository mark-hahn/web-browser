# web-browser package

A web browser that runs seamlessly in the Atom editor

![Animated GIF](https://github.com/mark-hahn/web-browser/blob/master/screenshots/browser.gif?raw=true)

This is a web browser tightly integrated into the Atom editor.  The web pages appear in the normal editor tabs.  The pages are fully functional with scripting and linking. A browser toolbar appears at the top of the Atom window to allow simple webpage navigation.

The browser is quite useful for testing a web page inside the same programming editor being used for development.  Splitting panes allow code to be seen next to the web page.

The browser has a simple API for other Atom packages to use.  @kgrossjo on the Atom discussion board suggested a package that allows clicking on a word in source code and showing the web page documention for the word.

### News (2014-11-02)

The package `command-toolbar` now supports buttons to save webpages and open them at any time with a single click.  This means that it can act as a "favorites" toolbar for this `web-browser` package.  It also provides buttons to execute any Atom command and open any text file, just like using the file tree.

## Usage
  
- Install with `apm install web-browser`
- Press `ctrl-alt-B` (`web-browser:toggle`) and a toolbar will appear above the tabs
- Enter a url and press enter
- To later create a new tab use ctrl-enter instead
- Press `ctrl-alt-B` again to refocus input
- Press `ctrl-alt-B` again to close toolbar
- Click on globe in toolbar to close the toolbar (secret feature)

## API

The API is not documented yet but the code in `lib/web-browser.coffee` contains all methods needed.  The `webBrowser` object is available as `atom.webBrowser` globally.  To open a page use `createPage`.  For example, to open the apple.com web page use `atom.webBrowser.createPage 'http://apple.com'`.

## Known Problems

- Missing features that will be added soon
  - Bookmarks
  - Recently visited sites
  - Options
  
  
- Missing features that may be added
  - Uploads and Downloads
  
  
- Features that will probably not be added
  - Plugins like Flash and Silverlight
  - Chrome Extensions (this isn't chrome (grin))
  
  
- Other
  - Tab keypresses are stolen from editor tabs
    - Close web browser toolbar to work around
  - Ctrl-click is ignored
  - Back/forward buttons reload pages
  - Same-origin problems from iFrame
    - Most of these have been fixed including the crashes
  
  
## License

Copyright Mark Hahn by MIT license
