
#= require slotcars/shared/models/car
#= require slotcars/play/views/car_view
#= require slotcars/shared/views/track_view
#= require slotcars/shared/lib/controllable
#= require slotcars/build/controllers/test_drive_controller
#= require slotcars/build/views/test_drive_view

Car = slotcars.shared.models.Car
TrackView = slotcars.shared.views.TrackView
Controllable = Slotcars.shared.lib.Controllable

Build.TestDrive = Ember.Object.extend

  stateManager: null
  buildScreenView: null
  track: null
  car: null

  init: ->
    @car = Car.create
      track: @track
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @_gameController = Build.TestDriveController.create
      stateManager: @stateManager
      track: @track
      car: @car

    @_gameController.set 'carControlsEnabled', true

    @_carView = Play.CarView.create car: @car
    @_trackView = TrackView.create
      track: @track
      gameController: @_gameController

    Controllable.apply @_trackView # this line is untested - don´t know how to do it

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
    @car.destroy()
    @_gameController.destroy()
