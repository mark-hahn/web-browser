
# lib/page-view

{$, View} = require 'atom-space-pen-views'
SubAtom   = require 'sub-atom'
urlUtil   = require 'url'

module.exports =
class PageView extends View
  
  @content = ->
    @div class:'browser-page', tabindex:-1
      
  initialize: (@page) ->
    @subs = new SubAtom
    @browser = @page.getBrowser()
    @page.setView @
    
    @url = @normalizeUrl @page.getPath()
    @webview = $ """
      <webview class="native-key-bindings" src="#{@url}"
               plugins disablewebsecurity></webview>
    """
    @append @webview
    @webviewEle = @webview[0]
    
    process.nextTick =>
      @$tabFavicon = $ '<img class="tab-favicon">'
      tabBarView   = $(atom.views.getView(atom.workspace.getActivePane()))
                           .find('.tab-bar').view()
      $tabView     = $ tabBarView.tabForItem @page
      @tabEle      = $tabView[0]
      $tabView.append @$tabFavicon
      @$title = $tabView.find '.title'
      @$title.css paddingLeft: '2.7em'

      @loadingSetInterval = setInterval =>
        try
          loading = @webviewEle.isLoading()
          if @faviconLoading isnt loading
            @setFavicon (if loading then 'loading' else 'restore')
            if not loading then @update()
        catch e
      , 500
      
      @setEvents()
      @update()
  
  getPage: -> @page
      
  normalizeUrl: (url) ->
      if process.platform is 'win32' and
         (parts = /^(.*)(\W)([a-z])(:\/)(.*)$/.exec url)
        parts[0] = ''
        parts[3] = parts[3].toUpperCase()
        url = parts.join ''
      url.replace /\/$/, ''

  setURL: (@url, autoReload = no) ->
    @url = @normalizeUrl @url
    try 
      oldUrl = @normalizeUrl @webviewEle.getUrl()
    catch e
      console.log 'setURL exception', @url
    if @url isnt oldUrl
      @webview?.attr src: @url
      @update()
    if autoReload then setTimeout (=> @reload 'ignoreCache'), 200

  goBack:     -> @webviewEle.goBack()
  goForward:  -> @webviewEle.goForward()
  
  reload: (ignoreCache = no) -> 
    try 
      url = @webviewEle.getUrl()
    catch e
      console.log 'reload exception', @url
    if url is 'about:blank'
      @webview.attr src: @url
      @update()
    else 
      # console.log 'ignoreCache', ignoreCache
      if ignoreCache then @webviewEle.reloadIgnoringCache()
      else                @webviewEle.reload()
    
  toggleLive: ->
    if not @liveUrl then @liveUrl = @url
    else @liveUrl = null
    @page.setLive @liveUrl
    @update()
    
  toggleDev: ->
    if @webviewEle.isDevToolsOpened()
      @webviewEle.closeDevTools()
    else
      @webviewEle.openDevTools()

  update: ->
    # console.log 'update', @url
    # @page.setURL @url
    @setFavicon urlUtil.parse(@url).hostname
    @title ?= @page.getTitle()
    @page.setTitle @title
    # @tabEle.updateTitle @title
    @$title.text @title
    if @liveUrl then @tabEle.classList.add    'live'
    else             @tabEle.classList.remove 'live'
    try
      canGoBack    = @webviewEle.canGoBack()
      canGoForward = @webviewEle.canGoForward()
    catch e
      canGoBack = canGoForward = null
    @browser.setNavControls
      goBack:        @goBack    .bind @
      goForward:     @goForward .bind @
      reload:        @reload    .bind @
      toggleLive:    @toggleLive.bind @
      toggleDev:     @toggleDev .bind @
      pageShowing:   yes
      canGoBack:     canGoBack
      canGoForward:  canGoForward
      canToggleLive: yes
      url:           @url
    , @page

  setFavicon: (domain) ->
    # #console.log 'setFavicon', domain
    setLoad = (setLoadIndicator = (domain is 'loading')) or
              (clrLoadIndicator = (domain is 'restore'))
    if domain and not setLoad then @domain =  domain
    else if clrLoadIndicator  then  domain = @domain
    @$tabFavicon.attr src:
      (if setLoadIndicator then 'atom://web-browser/images/loading-indicator.svg' \
       else "http://www.google.com/s2/favicons?domain=#{domain}")
    @faviconLoading = setLoadIndicator

  setEvents: ->
    @subs.add @webview, 'did-start-loading', (e) =>
      # console.log 'webview did-start-loading'
      @setFavicon 'loading'

    @subs.add @webview, 'did-get-redirect-request', (e) =>
      #console.log 'webview did-get-redirect-request', e.originalEvent.newUrl
      # @page.setURL @normalizeUrl e.originalEvent.newUrl

    @subs.add @webview, 'did-finish-load', =>
      @title = @webviewEle.getTitle()
      url    = @normalizeUrl @webviewEle.getUrl()
      if url is 'about:blank'
        console.log 'webview error: returned about:blank', @url
      else
        @url = url
        # console.log 'webview did-finish-load', @url
        @update()
    
    @subs.add @webview, 'did-fail-load', (e) =>
      url   = @webviewEle.getUrl()
      title = @webviewEle.getTitle()
      {errorCode, errorDescription} = e.originalEvent
      console.log 'webview did-fail-load', {url, title, errorCode, errorDescription}

    @subs.add @webview, 'did-frame-finish-load', (e) =>
      url   = @webviewEle.getUrl()
      title = @webviewEle.getTitle()
      {isMainFrame} =  e.originalEvent
      # console.log 'webview did-frame-finish-load', url, isMainFrame

    @subs.add @webview, 'did-stop-loading', =>
      # console.log 'webview did-stop-loading', {@url, wvurl: @webviewEle.getUrl()}

    @subs.add @webview, 'close', =>
      # console.log 'webview close'

    @subs.add @webview, 'crashed', =>
      console.log 'webview crashed'

    @subs.add @webview, 'destroyed', =>
      # console.log 'webview destroyed'

    @subs.add @webview, 'new-window', (e) =>
      newUrl = @normalizeUrl e.originalEvent.url
      # console.log 'webview new-window', newUrl
      @browser.createPage newUrl

    @subs.add @webview, 'console-message', (e) =>
      {level, message, line, sourceId} = e.originalEvent
      # #console.log 'webview console-message', level, line, sourceId, '\n"'+message+'"'
      console.log '%c' + message, 'color: #00f'

  destroy: ->
    clearInterval @loadingSetInterval
    @subs.dispose?()
    @webview.remove()
    @webview = null
    @detach()
