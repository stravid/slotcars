Build.TestDrive = Ember.Object.extend

  buildScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = Shared.BaseGameController.create
      track: @track
      car: @car

    @_gameController.set 'carControlsEnabled', true

    @_carView = Play.CarView.create car: @car
    @_trackView = Shared.TrackView.create
      track: @track
      gameController: @_gameController

    Shared.Controllable.apply @_trackView # this line is untested - don´t know how to do it

    @_baseGameViewContainer = Shared.BaseGameViewContainer.create()

    @_appendViews()


  start: ->
    @_gameController.start()

  _appendViews: ->
    @_baseGameViewContainer.set 'trackView', @_trackView
    @_baseGameViewContainer.set 'carView', @_carView

    @buildScreenView.set 'contentView', @_baseGameViewContainer

  destroy: ->
    @buildScreenView.set 'contentView', null
    @_carView.destroy()
    @_trackView.destroy()
    @_baseGameViewContainer.destroy()
    @_gameController.destroy()
