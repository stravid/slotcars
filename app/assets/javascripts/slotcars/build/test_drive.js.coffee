Build.TestDrive = Ember.Object.extend

  buildScreenView: null
  track: null
  car: null

  init: ->
    @_gameController = Build.TestDriveController.create
      stateManager: @stateManager
      track: @track
      car: @car

    @_gameController.set 'carControlsEnabled', true

    @_carView = Play.CarView.create car: @car
    @_trackView = Shared.TrackView.create
      track: @track
      gameController: @_gameController

    Shared.Controllable.apply @_trackView # this line is untested - don´t know how to do it

    @_testDriveView = Build.TestDriveView.create
      testDriveController: @_gameController

    @_testDriveView.set 'trackView', @_trackView
    @_testDriveView.set 'carView', @_carView

    @buildScreenView.set 'contentView', @_testDriveView

  start: ->
    @_gameController.start()

  destroy: ->
    @buildScreenView.set 'contentView', null
    @_carView.destroy()
    @_trackView.destroy()
    @_testDriveView.destroy()
    @_gameController.destroy()
