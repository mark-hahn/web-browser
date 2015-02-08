# Web-Browser package

A web browser that runs seamlessly in the Atom editor

![Image inserted by Atom editor package auto-host-markdown-image](http://i.imgur.com/i7A83Sa.gif)

This is a web browser tightly integrated into the Atom editor.  The web pages appear in the normal editor tabs.  The pages are fully functional with scripting and linking. A browser toolbar appears at the top of the Atom window to allow simple webpage navigation.

The browser is quite useful for testing a web page inside the same programming editor being used for development.  Splitting panes allow code to be seen next to the web page.

## Usage
  
- Install with `apm install web-browser`
- Press `ctrl-alt-B` (`web-browser:toggle`) and a toolbar will appear above the tabs
- Enter a url and press enter
- To later create a new tab use ctrl-enter instead
- Press `ctrl-alt-B` again to refocus input
- Press `ctrl-alt-B` again to close the toolbar
- Click on the globe in the toolbar to close the toolbar (secret feature)

## Auto-reload

Auto-reload is a feature that works much like a live-reload but is simpler and requires no setup.  The last button on the left (after the reload button) is the auto-reload button.

![Image inserted by Atom editor package auto-host-markdown-image](http://i.imgur.com/mwLCS6V.gif)

This button toggles the auto-reload feature for the visible webpage.  When the feature is enabled the page's tab shows a red dashed box around the page's favicon. You can toggle this feature on multiple pages at once.

![Image inserted by Atom editor package auto-host-markdown-image](http://i.imgur.com/OSMHJTf.gif)

This activates a simple live reload feature.  Whenever any source file in any tab is saved the web page is auto-reloaded.  There is a delay before the reload that can be set in settings.  The default is one second.  This delay gives the system time to process the file such as compiling coffeescript.

## Favorites

The package `command-toolbar` supports buttons to save webpages and open them at any time with a single click.  This means that it can act as a "favorites" toolbar for this web-browser package.

## API

This web-browser package listens for requests to open URLs.  This is anything that starts with `http://` or `https://`.  To open a webpage from code use the `atom.workspace.open` command with such a URL.
  
## License

Copyright Mark Hahn by MIT license
