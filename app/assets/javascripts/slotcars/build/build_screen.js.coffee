
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/build/test_drive
#= require slotcars/shared/models/track
#= require slotcars/shared/models/car
#= require slotcars/build/build_screen_state_manager
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable
#= require slotcars/build/rasterizer

Build.BuildScreen = Ember.Object.extend Shared.Appendable,

  _builder: null
  _buildScreenStateManager: null

  init: ->
    @_buildScreenStateManager = Build.BuildScreenStateManager.create delegate: this
    @view = Build.BuildScreenView.create stateManager: @_buildScreenStateManager

    @_buildScreenStateManager.goToState 'Drawing'

  setupDrawing: ->
    @track = Shared.Track.createRecord()

    @_builder = Build.Builder.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

  teardownDrawing: ->
    @_builder.destroy()

  setupTesting: ->
    @_testDrive = Build.TestDrive.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

    @_testDrive.start()

  teardownTesting: ->
    @_testDrive.destroy()

  setupRasterizing: ->
    @_rasterizer = Build.Rasterizer.create
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

  toString: -> '<Instance of Build.BuildScreen>'


Shared.ScreenFactory.getInstance().registerScreen 'BuildScreen', Build.BuildScreen
