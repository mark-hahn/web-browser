
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
    Page        = page.constructor
    url         = page.getURL()
    omnibox     = page.getOmnibox()
    omniboxView = omnibox.getView()
    
    @iframe.attr src: url
    
    @urlInterval = setInterval =>
      if not omniboxView.focused() 
        if (url = @iframe[0].contentWindow?.location.href)
          omniboxView.setURL url
          $('.workspace .tab.active .title').text page.getClass().calcTitle url
    , 100
    
  destroy: ->
    clearInterval @urlInterval
    @detach()

  