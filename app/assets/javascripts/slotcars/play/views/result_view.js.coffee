Play.ResultView = Ember.View.extend

  elementId: 'lap-time-view'
  templateName: 'slotcars_play_templates_result_view_template'
  gameController: null

  raceTime: 0

  didInsertElement: ->
    @_super()
    @onRaceTimeChange()
    @$('.spinner').spin lines: 9, length: 5, width: 4, radius: 5

  onRestartClick: -> @gameController.restartGame()

  onRaceTimeChange: (->
    return unless @gameController?
    @set 'raceTime', Shared.racetimeString (@gameController.get 'raceTime')
  ).observes 'gameController.raceTime'
