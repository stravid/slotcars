
#= require helpers/namespace
#= require slotcars/shared/models/car
#= require slotcars/play/views/car_view
#= require slotcars/play/views/game_view
#= require slotcars/play/controllers/game_controller
#= require slotcars/shared/views/track_view

namespace 'slotcars.play'

Car = slotcars.shared.models.Car
CarView = slotcars.play.views.CarView
GameController = slotcars.play.controllers.GameController
GameView = slotcars.play.views.GameView
TrackView = slotcars.shared.views.TrackView

slotcars.play.Game = Ember.Object.extend

  playScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = GameController.create track: @track, car: @car

    @_carView = CarView.create car: @car
    @_trackView = TrackView.create()
    @_gameView = GameView.create gameController: @_gameController

    @_appendViews()

  start: ->
    @_trackView.drawTrack @track.raphaelPath
    @_gameController.start()

  _appendViews: ->
    @playScreenView.set 'trackView', @_trackView
    @playScreenView.set 'carView', @_carView
    @playScreenView.set 'contentView', @_gameView
