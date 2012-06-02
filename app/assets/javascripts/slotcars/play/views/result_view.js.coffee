Play.ResultView = Ember.View.extend

  elementId: 'lap-time-view'
  templateName: 'slotcars_play_templates_result_view_template'
  gameController: null
  
  raceTime: 0
  
  didInsertElement: -> @onRaceTimeChange()

  onRestartClick: -> @gameController.restartGame()
  
  onRaceTimeChange: (->
    return unless @gameController?
    @set 'raceTime', Shared.racetimeString (@gameController.get 'raceTime') 
  ).observes 'gameController.raceTime'
