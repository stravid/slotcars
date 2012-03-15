
#= require helpers/namespace
#= require slotcars/shared/models/car
#= require slotcars/play/views/car_view
#= require slotcars/play/views/game_view
#= require slotcars/play/views/clock_view
#= require slotcars/play/controllers/game_controller
#= require slotcars/shared/views/track_view

namespace 'slotcars.play'

GameController = slotcars.play.controllers.GameController
CarView = slotcars.play.views.CarView
GameView = slotcars.play.views.GameView
ClockView = slotcars.play.views.ClockView
Car = slotcars.shared.models.Car
TrackView = slotcars.shared.views.TrackView

slotcars.play.Game = Ember.Object.extend

  playScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = GameController.create track: @track, car: @car

    @_carView = CarView.create car: @car
    @_trackView = TrackView.create gameController: @_gameController

    @_gameView = GameView.create gameController: @_gameController
    @_clockView = ClockView.create 
      gameController: @_gameController
      carModel: @car
      trackModel: @track

    @_appendViews()

  start: ->
    @_trackView.drawTrack @track.raphaelPath
    @_gameController.start()

  _appendViews: ->
    @playScreenView.set 'trackView', @_trackView
    @playScreenView.set 'carView', @_carView
    @playScreenView.set 'contentView', @_gameView
    @playScreenView.set 'clockView', @_clockView
