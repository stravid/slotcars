
#= require game/views/game_view
#= require game/mediators/game_mediator

#= require game/controllers/car_controller

describe 'game.views.GameView (functional)', ->

  GameView = game.views.GameView
  GameMediator = game.mediators.GameMediator

  # it 'should display a div with race time', ->
  #   gameView = GameView.create
  #     body: jQuery '<div>'
  #     mediator: GameMediator.create() 

  #   console.log gameView
  #   container = jQuery '<div>'
  #   Ember.run =>
  #     gameView.append()

  #   (expect container).toContain '#race-time'
  #   (expect gameView.formattedRaceTime()).not.toBeEmpty()


  it 'should update race time when it changes', ->
    gameMediator = GameMediator.create()
    timeValue = 28
    
    gameView = GameView.create
      mediator: gameMediator
    
    gameMediator.set 'raceTime', timeValue
    
    (expect gameView.get 'raceTimeInSeconds').toBe gameView.formatTime timeValue

  # it 'should display a button to restart the game', ->
  #   gameView = GameView.create
  #     body: jQuery '<div>'
  #     mediator: GameMediator.create()

  #   (expect gameView.container).toContain gameView.restartButton


