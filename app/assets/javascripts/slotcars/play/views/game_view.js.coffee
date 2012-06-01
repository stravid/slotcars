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

  onCountdownVisibleChange: ( ->
    if @gameController.get 'isCountdownVisible'
      (@$ '#countdown').removeClass 'hidden'
    else 
      (@$ '#countdown').addClass 'hidden'
  ).observes 'gameController.isCountdownVisible'
