fixedLength = (number, length = 2) ->
  string = '' + number

  string = '0' + string while string.length < length

  string.substring 0, 2


Handlebars.registerHelper 'racetime', (property) ->
  value = Ember.getPath this, property

  date = new Date()
  date.setTime value
    
  minutes = fixedLength date.getMinutes()
  seconds = fixedLength date.getSeconds()
  milliseconds = fixedLength date.getMilliseconds()

  new Handlebars.SafeString "#{minutes}:#{seconds}:#{milliseconds}"