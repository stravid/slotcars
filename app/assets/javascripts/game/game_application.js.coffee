
#= require helpers/namespace

#= require game/controllers/game_controller
#= require game/controllers/game_loop_controller

#= require game/views/car
#= require game/views/track_view
#= require game/views/game_view

#= require game/mediators/game_mediator
#= require game/mediators/track_mediator

namespace 'game'

game.GameApplication = Ember.View.extend

  elementId: 'game-application'

  didInsertElement: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupCar()
    @_setupGame()

    @_start()

  _start: ->
    @gameController.start()

  _setupRaphael: ->
    @paper = Raphael @$()[0], 1024, 768

  _setupTrack: ->
    @trackMediator = game.mediators.TrackMediator.create()
    game.views.TrackView.create
      mediator: @trackMediator
      paper: @paper

  _setupCar: ->
    @carMediator = game.mediators.CarMediator.create()
    game.views.CarView.create
      mediator: @carMediator
      paper: @paper

    @carController = game.controllers.CarController.create
      mediator: @carMediator
      acceleration: 0.1
      deceleration: 0.2
      offRoadDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @carController.setTrackPath @trackMediator.trackPath
    ($ @carController).on 'crossFinishLine', @carController.reset

  _setupGame: ->
    @gameMediator = game.mediators.GameMediator.create()

    gameView = game.views.GameView.create
      mediator: @gameMediator

    gameView.appendTo @$()
    
    @gameController = game.controllers.GameController.create
      mediator: @gameMediator
      carController: @carController
      gameLoopController: game.controllers.GameLoopController.create()
      gameView: gameView

