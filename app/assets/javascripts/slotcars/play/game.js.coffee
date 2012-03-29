
#= require slotcars/shared/models/car
#= require slotcars/play/views/car_view
#= require slotcars/play/views/game_view
#= require slotcars/play/views/clock_view
#= require slotcars/play/views/play_track_view
#= require slotcars/play/controllers/game_controller

GameController = slotcars.play.controllers.GameController
CarView = slotcars.play.views.CarView
GameView = slotcars.play.views.GameView
ClockView = slotcars.play.views.ClockView
Car = slotcars.shared.models.Car
PlayTrackView = slotcars.play.views.PlayTrackView

(namespace 'slotcars.play').Game = Ember.Object.extend

  playScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = GameController.create track: @track, car: @car

    @_carView = CarView.create car: @car
    @_trackView = PlayTrackView.create 
      track: @track
      gameController: @_gameController
    @_gameView = GameView.create gameController: @_gameController
    @_clockView = ClockView.create 
      gameController: @_gameController
      carModel: @car
      trackModel: @track

    @_appendViews()

  start: ->
    @_gameController.start()

  _appendViews: ->
    @playScreenView.set 'contentView', @_trackView
    @playScreenView.set 'carView', @_carView
    @playScreenView.set 'gameView', @_gameView
    @playScreenView.set 'clockView', @_clockView

  destroy: ->
    @_gameController.destroy()
