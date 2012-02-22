
#= require helpers/namespace
#= require game/controllers/game_controller

namespace 'game.controllers'

@game.controllers.GameApplication = Ember.Application.extend

  ready: ->
    game.controllers.GameController.create
      rootElement: $(@rootElement)[0]

    @paper = Raphael ($ @rootElement)[0], 1024, 768

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
