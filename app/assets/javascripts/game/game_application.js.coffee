
#= require helpers/namespace
#= require game/controllers/game_controller
#= require game/controllers/game_loop_controller

#= require game/views/car
#= require game/views/track
#= require game/views/game_view

namespace 'game'

@game.GameApplication = Ember.Application.extend

  ready: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupCar()
    @_setupGameController()

    @_start()

  _start: ->
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
      maxSpeed: 20
      traction: 100

    @carController.setTrackPath @trackMediator.trackPath
    ($ @carController).on 'crossFinishLine', @carController.reset

  _setupGameController: ->
    @gameMediator = game.mediators.GameMediator.create()
    
    game.views.GameView.create
      mediator: @gameMediator
      
    @gameController = game.controllers.GameController.create
      mediator: @gameMediator
      carController: @carController
      gameLoopController: game.controllers.GameLoopController.create()

