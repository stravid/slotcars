
#= require vendor/raphael

#= require game/mediators/track
#= require game/views/track

#= require game/mediators/car_mediator
#= require game/views/car
#= require game/controllers/car_controller

namespace 'game.controllers'

@game.controllers.GameController = Ember.Object.extend

  paper: null
  rootElement: null

  init: ->
    @_setupRaphael()
    @_setupTrack()
    @_setupCar()

  _setupRaphael: ->
    @paper = Raphael @rootElement, 1024, 768

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
    
  