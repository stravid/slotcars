
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/build/test_drive
#= require slotcars/shared/models/track
#= require slotcars/shared/models/car
#= require slotcars/build/build_screen_state_manager
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable
#= require slotcars/build/rasterizer

Builder = slotcars.build.Builder
TestDrive = Slotcars.build.TestDrive
Rasterizer = Slotcars.build.Rasterizer
BuildScreenView = slotcars.build.views.BuildScreenView
BuildScreenStateManager = Slotcars.build.BuildScreenStateManager
ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable

BuildScreen = (namespace 'slotcars.build').BuildScreen = Ember.Object.extend Appendable,

  _builder: null
  _buildScreenStateManager: null

  init: ->
    @_buildScreenStateManager = BuildScreenStateManager.create delegate: this
    @view = BuildScreenView.create stateManager: @_buildScreenStateManager

    @_buildScreenStateManager.goToState 'Drawing'

  setupDrawing: ->
    @track = slotcars.shared.models.Track.createRecord()

    @_builder = Builder.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

  teardownDrawing: ->
    @_builder.destroy()

  setupTesting: ->
    @_testDrive = TestDrive.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

    @_testDrive.start()

  teardownTesting: ->
    @_testDrive.destroy()

  setupRasterizing: ->
    @_rasterizer = Rasterizer.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

  startRasterizing: ->
    @_rasterizer.start()

  teardownRasterizing: ->
    @_rasterizer.destroy()

  destroy: ->
    @_super()
    @_buildScreenStateManager.destroy()

  toString: -> '<Instance of slotcars.build.BuildScreen>'


ScreenFactory.getInstance().registerScreen 'BuildScreen', BuildScreen
