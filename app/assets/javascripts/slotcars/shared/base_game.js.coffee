Shared.BaseGame = Ember.Object.extend

  screenView: null
  track: null
  car: null

  init: ->
    @_createGameController()
    @_createViews()
    @_applyMixins()
    @_appendViews()

  start: (enableCarControls) ->
    @_gameController.set 'carControlsEnabled', true if enableCarControls?
    @_gameController.start()

  _createGameController: ->
    @_gameController = Shared.BaseGameController.create
      track: @track
      car: @car

  _createViews: ->
    @_trackView = Shared.TrackView.create
      track: @track
      gameController: @_gameController

    @_carView = Play.CarView.create car: @car
    @_baseGameViewContainer = Shared.BaseGameViewContainer.create()

  _applyMixins: ->
    Shared.Controllable.apply @_trackView

  _appendViews: ->
    @_baseGameViewContainer.set 'trackView', @_trackView
    @_baseGameViewContainer.set 'carView', @_carView

    @screenView.set 'contentView', @_baseGameViewContainer

  destroy: ->
    @screenView.set 'contentView', null
    @_carView.destroy()
    @_trackView.destroy()
    @_baseGameViewContainer.destroy()
    @_gameController.destroy()
