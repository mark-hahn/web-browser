
# lib/page-view

{$, View} = require 'atom'

module.exports =
class PageView extends View
  
  @content: ->
    @div class:'browser-page', tabindex:-1, =>
      @iframe
        outlet:'iframe'
        class:'iframe'
        sandbox: 'allow-same-origin allow-scripts allow-top-navigation allow-forms allow-popups allow-pointer-lock'
        allowfullscreen: yes
        
  initialize: (page) ->
    page.setView @
    browser     = page.getBrowser()
    omniboxView = browser.getOmniboxView()
    Page        = page.constructor
    url         = page.getURL()
    
    @setLocation url
    
    @urlInterval = setInterval =>
      if not omniboxView.focused and 
          (url = @iframe[0].contentWindow?.location.href) and 
           url isnt @lastUrl
        @lastUrl = url
        browser.setOmniText url
        page.locationChanged url
        $('.workspace .tab.active .title').text Page.calcTitle url
    , 100
    
  setLocation: (url) -> @iframe.attr src: url
    
  destroy: ->
    clearInterval @urlInterval
    @detach()

  