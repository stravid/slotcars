Play.ResultView = Ember.View.extend

  elementId: 'lap-time-view'
  templateName: 'slotcars_play_templates_result_view_template'
  gameController: null
  
  raceTime: 0
  lapTimes: []
  
  didInsertElement: ->
    @onLapTimesChange()
    @onRaceTimeChange()

  onLapTimesChange: (->
    return unless @gameController?
    
    times = []
    milliSeconds = @gameController.get 'lapTimes'
    
    for time, i in milliSeconds
      times[i] = "lap #{i + 1}: #{@_formatTime time}"
      
    @set 'lapTimes', times
  ).observes 'gameController.lapTimes'
  
  onRaceTimeChange: (->
    return unless @gameController?
    @set 'raceTime', @_formatTime (@gameController.get 'raceTime') 
  ).observes 'gameController.raceTime'
  
  _formatTime: (value) ->
    date = new Date()
    date.setTime value
    
    minutes = @_formatNumber date.getMinutes()
    seconds = @_formatNumber date.getSeconds()
    milliseconds = @_formatNumber date.getMilliseconds()
    
    "#{minutes}:#{seconds}:#{milliseconds}"
    
  _formatNumber: (value) ->
    string = value.toString()
    if string.length < 2 then '0' + string else string
    
