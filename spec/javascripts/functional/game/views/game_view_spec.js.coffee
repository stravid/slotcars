
#= require game/views/game_view
#= require game/mediators/game_mediator

#= require game/controllers/car_controller

describe 'game.views.GameView (functional)', ->

  GameView = game.views.GameView

  it 'should update race time when it changes', ->
    timeValue = 28
    gameMediator = Ember.Object.create()

    gameView = GameView.create
      gameMediator: gameMediator

    gameMediator.set 'raceTime', timeValue

    (expect gameView.get 'raceTimeInSeconds').toBe gameView.formatTime timeValue