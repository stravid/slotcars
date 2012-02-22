
#= require helpers/namespace
#= require game/controllers/game_controller
#= require game/controllers/game_loop_controller

namespace 'game.controllers'

@game.controllers.GameApplication = Ember.Application.extend

  ready: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupCar()
    @_setupGameController()

    @start()

  start: ->
    @gameController.start()

  _setupRaphael: ->
    @paper = Raphael ($ @rootElement)[0], 1024, 768

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
      maxSpeed: 5

    @carController.setTrackPath @trackMediator.trackPath

  _setupGameController: ->
    @gameController = game.controllers.GameController.create
      carController: @carController
      gameLoopController: game.controllers.GameLoopController.create()

