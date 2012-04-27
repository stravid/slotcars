Shared.racetimeString = (racetime) ->
  date = new Date(racetime)
    
  minutes = Shared.fixedLengthNumber date.getMinutes()
  seconds = Shared.fixedLengthNumber date.getSeconds()
  milliseconds = Shared.fixedLengthNumber date.getMilliseconds()

  "#{minutes}:#{seconds}:#{milliseconds}"