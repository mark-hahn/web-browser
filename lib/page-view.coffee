
# lib/page-view

urlUtil   = require 'url'
{$, View} = require 'atom'

module.exports =
class PageView extends View
  
  @content: ->
    @div class:'browser-page', tabindex:-1, =>
      @tag 'webview'
        # class:    'webview'
        # name:     'browser-page-disable-x-frame-options'
        # sandbox:  'allow-forms allow-popups allow-pointer-lock allow-same-origin allow-scripts'
        # allowfullscreen: yes
        
  initialize: (page) ->
    @webview = @find('webview')[0]
    
    page.setView @
    browser     = page.getBrowser()
    omniboxView = browser.getOmniboxView()
    tabBarView  = atom.workspaceView.find('.pane.active').find('.tab-bar').view()
    tabView     = tabBarView.tabForItem page
    $tabView    = $ tabView
    url         = page.getPath()
    
    #debug
    # @subscribe @, 'click', (e) => console.log 'PageView click', e.ctrlKey
    
    @setLocation url
    
    $(@webview).on 'did-start-loading', (e)->
      console.log 'did-start-loading event'

    $(@webview).on 'new-window', (e)->
      console.log 'new-window event'
      
    # @webview.openDevTools()

    # @webview.addEventListener 'new-window', (e)->
    #   require('shell').openExternal e.url
    #   
    # $(@webview).on 'new-window', (e) ->
    #   console.log 'page-view.coffee(38) new-window', e
    #   try
    #     theUrl = urlUtil.parse e.url
    #     throw new Error("Invalid protocol") unless theUrl.protocol in ['http:', 'https:', 'mailto:']
    #     require('shell').openExternal(e.url)
    #   catch error
    #     console.log "Ignoring #{e.url} due to #{error.message}"
    
    @webview.addEventListener 'did-start-loading', =>
      url   = @webview.getUrl()
      title = @webview.getTitle()
      page.locationChanged url
      page.setTitle title
      
      # $body.append "<script>console.log('xxx')</script>"
      # console.log '@webview.contents', {url, title}
      
    @$tabFavicon = $ '<img class="tab-favicon">'
    $tabView.append @$tabFavicon
    $tabView.find('.title').css paddingLeft: 20
  
  setFaviconDomain: (domain) -> 
    @$tabFavicon.attr src: "http://www.google.com/s2/favicons?domain=#{domain}"
    
  setLocation: (url) -> $(@webview).attr src: url
    
  destroy: ->
    clearInterval @urlInterval
    @detach()

