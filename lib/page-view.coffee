
# lib/page-view

{$, View} = require 'atom'

module.exports =
class PageView extends View
  
  @content: ->
    @div class:'browser-page', tabindex:-1, =>
      @iframe
        outlet:   'iframe'
        class:    'iframe'
        name:     'browser-page-disable-x-frame-options'
        sandbox:  'allow-forms allow-popups allow-pointer-lock allow-same-origin allow-scripts'
        allowfullscreen: yes
        
  initialize: (page) ->
    page.setView @
    browser     = page.getBrowser()
    omniboxView = browser.getOmniboxView()
    tabBarView  = atom.workspaceView.find('.pane.active').find('.tab-bar').view()
    tabView     = tabBarView.tabForItem page
    $tabView    = $ tabView
    url         = page.getPath()
    
    #debug
    @subscribe @, 'click', (e) => console.log 'PageView click', e.ctrlKey
    
    @setLocation url
    
    @subscribe @iframe, 'load', =>
      iframeEle = @iframe[0]
      page.locationChanged (url = iframeEle.contentWindow.location.href)
      page.setTitle iframeEle.contentDocument.title
      tabView.updateTitle()
      
    @$tabFavicon = $ '<img class="tab-favicon">'
    $tabView.append @$tabFavicon
    $tabView.find('.title').css paddingLeft: 20
  
  setFaviconDomain: (domain) -> 
    @$tabFavicon.attr src: "http://www.google.com/s2/favicons?domain=#{domain}"
    
  setLocation: (url) -> @iframe.attr src: url
    
  destroy: ->
    clearInterval @urlInterval
    @detach()

