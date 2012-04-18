
#= require slotcars/play/views/car_view
#= require slotcars/play/views/game_view
#= require slotcars/play/views/clock_view
#= require slotcars/play/views/play_track_view
#= require slotcars/play/controllers/game_controller
#= require slotcars/shared/lib/controllable

Controllable = Slotcars.shared.lib.Controllable

Play.Game = Ember.Object.extend

  playScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = Play.GameController.create track: @track, car: @car

    @_carView = Play.CarView.create car: @car
    @_trackView = Play.PlayTrackView.create 
      track: @track
      gameController: @_gameController

    Controllable.apply @_trackView # this line is untested - don´t know how to do it

    @_gameView = Play.GameView.create gameController: @_gameController
    @_clockView = Play.ClockView.create
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
