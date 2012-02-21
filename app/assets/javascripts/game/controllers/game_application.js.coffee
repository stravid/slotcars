
#= require helpers/namespace
#= require game/controllers/game_controller

namespace 'game.controllers'

@game.controllers.GameApplication = Ember.Application.extend

  ready: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupCar()
    @_setupGameController()

  _setupRaphael: ->
    @paper = Raphael $(@rootElement)[0], 1024, 768

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

    @carController.setTrackPath @trackMediator.trackPath

  _setupGameController: ->
    game.controllers.GameController.create
      carController: @carController

