# web-browser package

A web browser that runs seamlessly in the Atom editor

![Animated GIF](https://github.com/mark-hahn/web-browser/blob/master/screenshots/browser.gif?raw=true)

**Warning:** This is a preliminary version.  Visiting certain pages (see *Typical Incompatible Websites* below) will cause the Atom window to crash and disappear.  If you are browsing arbitrary pages make sure you work is saved. 

This is a web browser tightly integrated into the Atom editor.  The web pages appear in the normal editor tabs.  The pages are fully functional with scripting and linking. A browser toolbar appears at the top of the Atom window to allow simple webpage navigation.

The browser is quite useful for testing a web page inside the same programming editor being used for development.  Splitting panes allow code to be seen next to the web page.

The browser has a simple API for other Atom packages to use.  @kgrossjo on the Atom discussion board suggested a package that allows clicking on a word in source code and showing the web page documention for the word.

At this time the web-browser is not a replacement for a general-purpose web browser because of a lack of features and serious incompatibility (crashes) with a number of websites (see *Typical Incompatible Websites* below).  It is hoped that both of these problems will be fixed in future versions.

## Usage
  
- Install with `apm install web-browser`
- Press `ctrl-alt-B` (`web-browser:toggle`) and a toolbar will appear above the tabs
- Enter a complete url including the `http://` at the beginning and press enter
- To create a new tab use ctrl-enter instead

## API

The API is not documented yet but the code in `lib/web-browser.coffee` contains all methods needed.  The `webBrowser` object is available as `atom.webBrowser` globally.  To open a page use `createPage`.  For example, to open the apple.com web page use `atom.webBrowser.createPage 'http://apple.com'`.

## Typical Incompatible Websites

I checked about 25 websites from my bookmarks and all worked except the ones below.  I'm suspicious that login-forms have some correlation with the big problem shown first.

- These cause the window to crash (disappear), presumably due to a bug in the atom-shell
  - gmail.com
  - github.com
  - netflix.com
  - get.adobe.com/flashplayer
  - verizon.com login submission
  
  
- youtube.com and youtube videos work but the full-screen option doesn't

- bitcoincharts.com has code to check if in an iFrame which causes it to fail

      if (parent != null && parent != self) {
        if(parent.location.hostname != self.location.hostname) {
          top.location.href=self.location.href; 
        }
      }

- Install Silverlight button in amazon.com did nothing
  

## License

Copyright Mark Hahn by MIT license