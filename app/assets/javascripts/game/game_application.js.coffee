
#= require helpers/namespace

#= require game/controllers/game_controller
#= require game/controllers/game_loop_controller

#= require game/views/car_view
#= require game/views/track_view
#= require game/views/game_view

namespace 'game'

TrackModel = shared.models.TrackModel

game.GameApplication = Ember.View.extend

  elementId: 'game-application'

  trackView: null

  carView: null
  carController: null

  gameView: null
  gameController: null

  paper: null

  didInsertElement: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupCar()
    @_setupGame()

    @gameController.start()

  _setupRaphael: ->
    @paper = Raphael @$()[0], 1024, 650

  _setupTrack: ->
    @trackView = game.views.TrackView.create
      paper: @paper

  _setupCar: ->
    #@carView = game.views.CarView.create
    #  paper: @paper
    #  offset: (jQuery @$()).offset()

    #@carView.appendTo @$()

    # @car = game.lib.Car.create
    #   acceleration: 0.1
    #   deceleration: 0.2
    #   offRoadDeceleration: 0.15
    #   maxSpeed: 20
    #   traction: 100

  _setupGame: ->
    currentTrackMediator = shared.mediators.currentTrackMediator

    @gameController = game.controllers.GameController.create
      track: currentTrackMediator.currentTrack
      gameLoopController: game.controllers.GameLoopController.create()

    @gameView = game.views.GameView.create
      gameController: @gameController

    @gameView.appendTo @$()
