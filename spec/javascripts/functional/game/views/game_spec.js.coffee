
#= require game/views/game_view
#= require game/mediators/game_mediator

#= require game/controllers/car_controller

describe 'game.views.GameView (functional)', ->

  GameView = game.views.GameView
  GameMediator = game.mediators.GameMediator

  it 'should update race time when it changes', ->
    gameMediator = GameMediator.create()
    timeValue = 28

    gameView = GameView.create
      mediator: gameMediator

    gameMediator.set 'raceTime', timeValue

    (expect gameView.get 'raceTimeInSeconds').toBe gameView.formatTime timeValue