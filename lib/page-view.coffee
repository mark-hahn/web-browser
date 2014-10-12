
# lib/page-view

{$, View} = require 'atom'

module.exports =
class PageView extends View
  
  @content: ->
    @div class:'browser-page', tabindex:-1, =>
      @iframe
        name: 'disable-x-frame-options'
        outlet:'iframe'
        class:'iframe'
        sandbox: 'none'
        allowfullscreen: yes
        
  initialize: (page) ->
    page.setView @
    browser     = page.getBrowser()
    omniboxView = browser.getOmniboxView()
    url         = page.getLocation()
    
    @setLocation url
    setTimeout =>
      @$tabTitle = $ '.workspace .tab.active .title'
    , 100
    
    @urlInterval = setInterval =>
      if not omniboxView.focused
        url = @iframe[0].contentWindow?.location.href ? ''
        if url isnt @lastUrl
          @lastUrl = url
          if (browser.getActivePage() is page)
            page.locationChanged url
            if (title = page.calcTitle url)
              @$tabTitle?.text title
    , 100
    
  setLocation: (url) -> @iframe.attr src: url
    
  destroy: ->
    clearInterval @urlInterval
    @detach()

  