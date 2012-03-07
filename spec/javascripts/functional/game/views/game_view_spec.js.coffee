
#= require game/views/game_view
#= require game/controllers/game_controller

describe 'game.views.GameView (functional)', ->

  GameView = game.views.GameView
  GameController = game.controllers.GameController

  beforeEach ->
    @gameController = GameController.create
      track: Ember.Object.create()  # real track is not necessary here

    @gameView = GameView.create
      gameController: @gameController

  it 'should update race time when it changes', ->
    timeValue = 28
    @gameController.set 'raceTime', timeValue

    (expect @gameView.get 'raceTimeInSeconds').toBe @gameView.convertMillisecondsToSeconds timeValue