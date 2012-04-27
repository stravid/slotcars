Handlebars.registerHelper 'racetime', (property) ->
  value = Ember.getPath this, property

  date = new Date()
  date.setTime value
    
  minutes = Shared.fixedLengthNumber date.getMinutes()
  seconds = Shared.fixedLengthNumber date.getSeconds()
  milliseconds = Shared.fixedLengthNumber date.getMilliseconds()

  new Handlebars.SafeString "#{minutes}:#{seconds}:#{milliseconds}"