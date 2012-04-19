
#= require slotcars/play/templates/game_view_template
#= require slotcars/play/views/result_view

Play.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'slotcars_play_templates_game_view_template'
  gameController: null
  overlayView: null

  onRestartClick: ->
    @gameController.restartGame()

  onRaceStatusChange: ( ->
    if @gameController.get 'isRaceFinished'
      @set 'overlayView', Play.ResultView.create
        gameController: @get 'gameController'

  ).observes 'gameController.isRaceFinished'

  raceTimeInSeconds: (Ember.computed ->
    @convertMillisecondsToSeconds (@gameController.get 'raceTime')
  ).property 'gameController.raceTime'

  onCountdownVisibleChange: ( ->
    if @gameController.get 'isCountdownVisible'
      (@$ '#countdown').removeClass 'squashed'
    else 
      (@$ '#countdown').addClass 'squashed'
  ).observes 'gameController.isCountdownVisible'

  convertMillisecondsToSeconds: (value) ->
    value / 1000
