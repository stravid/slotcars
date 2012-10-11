Shared.BaseGame = Ember.Object.extend

  screenView: null
  track: null
  car: null

  init: ->
    @_createGameController()
    @_createViews()
    @_applyMixins()
    @_appendViews()

  start: (startRaceImmediately) ->
    @_gameController.set 'isRaceRunning', true if startRaceImmediately?
    @_gameController.start()

  _createGameController: ->
    @_gameController = Shared.BaseGameController.create
      track: @track
      car: @car

  _createViews: ->
    @_trackView = Shared.TrackView.create
      track: @track
      car: @car
      gameController: @_gameController

    @_carView = Play.CarView.create car: @car
    @_baseGameViewContainer = Shared.BaseGameViewContainer.create()

  _applyMixins: ->
    Shared.CanvasRenderable.apply @_trackView
    Shared.Controllable.apply @_trackView
    Shared.Panable.apply @_trackView

  _appendViews: ->
    @_baseGameViewContainer.set 'trackView', @_trackView
    @_baseGameViewContainer.set 'carView', @_carView
    @screenView.set 'contentView', @_baseGameViewContainer

  _removeViews: ->
    @_baseGameViewContainer.set 'trackView', null
    @_baseGameViewContainer.set 'carView', null
    @screenView.set 'contentView', null

  _destroyViews: ->
    @_carView.destroy()
    @_trackView.destroy()
    @_baseGameViewContainer.destroy()

  destroy: ->
    @_removeViews()
    @_destroyViews()
    @_gameController.destroy()
    @_super()
