
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/build/test_drive
#= require slotcars/shared/models/track
#= require slotcars/shared/models/car
#= require slotcars/build/build_screen_state_manager
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

Builder = slotcars.build.Builder
TestDrive = Slotcars.build.TestDrive
Track = slotcars.shared.models.Track
Car = slotcars.shared.models.Car
BuildScreenView = slotcars.build.views.BuildScreenView
BuildScreenStateManager = Slotcars.build.BuildScreenStateManager
ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable

BuildScreen = (namespace 'slotcars.build').BuildScreen = Ember.Object.extend Appendable,

  _builder: null
  _buildScreenStateManager: null

  init: ->
    @view = BuildScreenView.create()
    @track = slotcars.shared.models.Track.createRecord()

    @_buildScreenStateManager = BuildScreenStateManager.create delegate: this
    @_buildScreenStateManager.goToState 'Drawing'

  prepareDrawing: ->
    @_builder = Builder.create
      buildScreenView: @view
      track: @track
      stateManager: @_buildScreenStateManager

  teardownDrawing: ->
    @_builder.destroy()

  prepareTesting: ->
    @_car = Car.create
      track: @track
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @_testDrive = TestDrive.create
      buildScreenView: @view
      track: @track
      car: @_car

  teardownTesting: ->
    @_car.destroy()
    @_testDrive.destroy()

  destroy: ->
    @_super()
    @_buildScreenStateManager.destroy()

  toString: -> '<Instance of slotcars.build.BuildScreen>'


ScreenFactory.getInstance().registerScreen 'BuildScreen', BuildScreen
