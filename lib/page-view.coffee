
# lib/page-view

{$, View} = require 'atom-space-pen-views'
SubAtom   = require 'sub-atom'
urlUtil   = require 'url'

module.exports =
class PageView extends View
  
  @content = ->
    @div class:'browser-page', tabindex:-1, =>
      @tag 'webview',
        class:             'native-key-bindings'
        outlet:            'webview'
        plugins:            yes
        disablewebsecurity: yes

  initialize: (@page) ->
    # @dbg = ++dbg
    # console.log 'initialize', @dbg
    
    @subs = new SubAtom
    @page.setView @
    @url        = @page.getPath()
    @browser    = @page.getBrowser()
    @webviewEle = @webview[0]
    @webview.attr src: @url
    
    process.nextTick =>
      # console.log 'process.nextTick'
      @$tabFavicon = $ '<img class="tab-favicon">'
      tabBarView   = $(atom.views.getView(atom.workspace.getActivePane()))
                           .find('.tab-bar').view()
      $tabView     = $ tabBarView.tabForItem @page
      @tabEle      = $tabView[0]
      $tabView.append @$tabFavicon
      $tabView.find('.title').css paddingLeft: '2.7em'

      # @oldSize = [0,0]
      @loadingSetInterval = setInterval =>
        try
          loading = @webviewEle.isLoading()
          if @faviconLoading isnt loading
            @setFavicon (if loading then 'loading' else 'restore')
            # if @needResizeBugFix and not loading 
            #   @page.resizeBugFix()
            #   @needResizeBugFix = no
        catch e
        # width  = @width()
        # height = @height()
        # if width isnt @oldSize[0] or height isnt @oldSize[1]
        #   @oldSize = [width, height]
        #   @needResizeBugFix = true
      , 500
      
      @setEvents()
      @setURL @url

  setURL: (@url) ->
    # console.log 'setURL', @.dbg, @url
    @url = @url.replace /\/$/, ''
    oldUrl = try 
        @webviewEle.getUrl().replace /\/$/, ''
    catch e
    if @url isnt oldUrl
      # console.log '@url isnt oldUrl', @.dbg, @url
      @webview.attr src: @url
      @update()
      
  goBack:     -> @webviewEle.goBack()
  goForward:  -> @webviewEle.goForward()
  reload:     -> @webviewEle.reload()
  toggleLive: ->
    @live = not @live
    @page.setLive @live
    @update()

  update: ->
    # console.log 'update', @.dbg
    @setFavicon urlUtil.parse(@url).hostname
    @title ?= @page.getTitle()
    @page.setTitle @title
    @tabEle.updateTitle @title
    if @live then @tabEle.classList.add    'live'
    else          @tabEle.classList.remove 'live'
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
      canReload:     yes
      canGoBack:     canGoBack
      canGoForward:  canGoForward
      canToggleLive: yes
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
      #console.log 'webview did-start-loading'
      @setFavicon 'loading'

    @subs.add @webview, 'did-get-redirect-request', (e) =>
      #console.log 'webview did-get-redirect-request', e.originalEvent.newUrl
      # @page.setURL e.originalEvent.newUrl.replace /\/$/, ''

    @subs.add @webview, 'did-finish-load', =>
      @title = @webviewEle.getTitle()
      @url   = @webviewEle.getUrl().replace /\/$/, ''
      #console.log 'webview did-finish-load', @url, @title
      @update()

    @subs.add @webview, 'did-fail-load', (e) =>
      url   = @webviewEle.getUrl()
      title = @webviewEle.getTitle()
      {errorCode, errorDescription} = e.originalEvent
      #console.log 'webview did-fail-load', {url, title, errorCode, errorDescription}
      # @setFavicon 'restore'

    @subs.add @webview, 'did-frame-finish-load', (e) =>
      url   = @webviewEle.getUrl()
      title = @webviewEle.getTitle()
      {isMainFrame} =  e.originalEvent
      #console.log 'webview did-frame-finish-load', url, isMainFrame
      # @setFavicon 'restore'

    @subs.add @webview, 'did-stop-loading', =>
      url   = @webviewEle.getUrl()
      title = @webviewEle.getTitle()
      #console.log 'webview did-stop-loading', {url, title, wvurl: @webviewEle.getUrl()}

    @subs.add @webview, 'close', =>
      #console.log 'webview close'

    @subs.add @webview, 'crashed', =>
      #console.log 'webview crashed'

    @subs.add @webview, 'destroyed', =>
      #console.log 'webview destroyed'

    @subs.add @webview, 'new-window', (e) =>
      newUrl = e.originalEvent.url.replace /\/$/, ''
      #console.log 'webview new-window', newUrl
      @browser.createPage newUrl

    @subs.add @webview, 'console-message', (e) =>
      {level, message, line, sourceId} = e.originalEvent
      # #console.log 'webview console-message', level, line, sourceId, '\n"'+message+'"'
      #console.log '%c' + message, 'color: #00f'

  destroy: ->
    clearInterval @loadingSetInterval
    @subs.dispose?()
    @webview.remove()
    @webview = null
    @detach()
