
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

Build.BuildScreen = Ember.Object.extend Shared.Appendable,

  _builder: null
  _buildScreenStateManager: null

  init: ->
    @_buildScreenStateManager = Build.BuildScreenStateManager.create delegate: this
    @view = Build.BuildScreenView.create stateManager: @_buildScreenStateManager

    @_buildScreenStateManager.goToState 'Drawing'

  setupDrawing: ->
    @track.deleteRecord() if @track?
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

  setupPublishing: ->
    @_publisher = Build.Publisher.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

  performPublishing: ->
    @_publisher.publish()

  teardownPublishing: ->
    @_publisher.destroy()

  destroy: ->
    @_super()
    @_buildScreenStateManager.destroy()
    @track.deleteRecord() if @track? and @track.get 'isDirty'

Shared.ScreenFactory.getInstance().registerScreen 'BuildScreen', Build.BuildScreen
