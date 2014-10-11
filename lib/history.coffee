
# lib/history

module.exports =
class History
  
  constructor: (url) ->
    @urlIndex = 0
    @urls = [url]
    console.log 'history constructor', @urlIndex, @urls
    
  back: -> 
    @urlIndex = Math.max @urlIndex-1, 0
    console.log 'history back', @urlIndex, @urls
    @urls[@urlIndex]
    
  forward: -> 
    @urlIndex = Math.min @urlIndex+1, @urls.length-1
    console.log 'history forward', @urlIndex, @urls
    @urls[@urlIndex]
    
  locationChanged: (url) -> 
    @urls = @urls[0..@urlIndex++].concat url
    console.log 'history locationChanged', @urlIndex, @urls
