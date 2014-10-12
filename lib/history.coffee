
# lib/history

module.exports =
class History
  
  constructor: (url) ->
    @urlIndex = 0
    @urls = [url]
    
  back: -> 
    @urlIndex = Math.max @urlIndex-1, 0
    @urls[@urlIndex]
    
  forward: -> 
    @urlIndex = Math.min @urlIndex+1, @urls.length-1
    @urls[@urlIndex]
    
  locationChanged: (url) -> 
    if url isnt @urls[@urlIndex]
      @urls = @urls[0..@urlIndex++].concat url
