Play.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'slotcars_play_templates_game_view_template'
  gameController: null
  overlayView: null

  onRestartClick: -> @gameController.restartGame()

  onQuickplayClick: -> Shared.routeManager.send 'quickplay'

  onRaceStatusChange: ( ->
    if @gameController.get 'isRaceFinished'
      @set 'overlayView', Play.ResultView.create
        gameController: @get 'gameController'

  ).observes 'gameController.isRaceFinished'
