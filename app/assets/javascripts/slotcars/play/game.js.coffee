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

    Shared.Controllable.apply @_trackView # this line is untested - don´t know how to do it

    @_gameView = Play.GameView.create gameController: @_gameController
    @_clockView = Play.ClockView.create
      gameController: @_gameController
      carModel: @car
      trackModel: @track

    @_baseGameViewContainer = Shared.BaseGameViewContainer.create()

    @_appendViews()

  start: ->
    @_gameController.start()

  _appendViews: ->
    @_baseGameViewContainer.set 'trackView', @_trackView
    @_baseGameViewContainer.set 'carView', @_carView
    @_baseGameViewContainer.set 'clockView', @_clockView
    @_baseGameViewContainer.set 'gameView', @_gameView

    @playScreenView.set 'contentView', @_baseGameViewContainer

  destroy: ->
    @_gameController.destroy()
