
#= require helpers/namespace
#= require vendor/raphael

#= require game/mediators/track
#= require game/views/track

#= require game/mediators/car_mediator
#= require game/views/car
#= require game/controllers/car_controller

namespace 'game.controllers'

@game.controllers.GameApplication = Ember.Application.extend

  paper: null

  ready: ->

    @paper = Raphael $(@rootElement)[0], 1024, 768

    trackMediator = game.mediators.TrackMediator.create()
    game.views.TrackView.create
      mediator: trackMediator
      paper: @paper

    carMediator = game.mediators.CarMediator.create()
    game.views.CarView.create
      mediator: carMediator
      paper: @paper

    carController = game.controllers.CarController.create
      mediator: carMediator

    carController.setTrackPath trackMediator.trackPath

    ($ carController).on 'crossFinishLine', carController.reset