Play.ResultView = Ember.View.extend

  elementId: 'lap-time-view'
  templateName: 'slotcars_play_templates_result_view_template'
  gameController: null
  
  raceTime: 0
  lapTimes: []
  
  didInsertElement: ->
    @onLapTimesChange()
    @onRaceTimeChange()

  onRestartClick: -> @gameController.restartGame()

  onLapTimesChange: (->
    return unless @gameController?
    
    times = []
    milliSeconds = @gameController.get 'lapTimes'
    
    for time, i in milliSeconds
      times[i] = "lap #{i + 1}: #{Shared.racetimeString time}"
      
    @set 'lapTimes', times
  ).observes 'gameController.lapTimes'
  
  onRaceTimeChange: (->
    return unless @gameController?
    @set 'raceTime', Shared.racetimeString (@gameController.get 'raceTime') 
  ).observes 'gameController.raceTime'
