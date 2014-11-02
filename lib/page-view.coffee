
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
    # @subscribe @, 'click', (e) => console.log 'PageView click', e.ctrlKey
    
    @setLocation url
    
    @subscribe @iframe, 'load', =>
      $document  = @iframe.contents()
      url        = $document[0].URL
      $head      = $document.find 'head'
      $body      = $document.find 'body'
      title      = $head.find('title').text()
      page.locationChanged url
      page.setTitle title
      
      # $body.append "<script>console.log('xxx')</script>"
      # console.log '@iframe.contents', {url, title}
      
    @$tabFavicon = $ '<img class="tab-favicon">'
    $tabView.append @$tabFavicon
    $tabView.find('.title').css paddingLeft: 20
  
  setFaviconDomain: (domain) -> 
    @$tabFavicon.attr src: "http://www.google.com/s2/favicons?domain=#{domain}"
    
  setLocation: (url) -> @iframe.attr src: url
    
  destroy: ->
    clearInterval @urlInterval
    @detach()

