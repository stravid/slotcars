
#= require helpers/namespace

#= require game/controllers/game_controller
#= require game/controllers/game_loop_controller

#= require game/views/car
#= require game/views/track_view
#= require game/views/game_view

#= require game/mediators/game_mediator
#= require game/mediators/track_mediator

#= require game/models/track_model

namespace 'game'

TrackModel = game.models.TrackModel

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
      trackMediator: @trackMediator
      paper: @paper

    trackModel = TrackModel._create
      path: 'M89.587,153.254c26.19-53.175,35.714-80.159,111.111-69.048 s138.889,34.127,120.635-8.73s-36.507-54.762,93.651-43.651s223.81,91.271,204.762,257.937 c-19.048,166.666-73.809,44.445-41.27,35.715s26.984-22.225,29.365-43.652S589.587,58.81,489.587,195.317 c-100,136.507-66.666,134.919-30.158,123.81c36.508-11.111,98.412-11.904,59.523,74.604s-210.317,34.127-225.396,30.158 S145.143,371.508,179.27,319.127s47.619-99.207,13.492-120.635s-134.92,96.032-69.047,182.54s-32.54,92.857-80.159,17.461 S89.587,153.254,89.587,153.254z'

    @trackMediator.set 'currentTrack', trackModel

  _setupCar: ->
    @carMediator = game.mediators.CarMediator.create()
    game.views.CarView.create
      mediator: @carMediator
      paper: @paper

    @carController = game.controllers.CarController.create
      carMediator: @carMediator
      trackMediator: @trackMediator
      acceleration: 0.1
      deceleration: 0.2
      offRoadDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    (jQuery @carController).on 'crossFinishLine', @carController.reset

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

