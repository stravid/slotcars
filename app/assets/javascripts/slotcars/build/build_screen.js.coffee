#= require slotcars/factories/screen_factory

Build.BuildScreen = Ember.Object.extend

  view: null
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

  teardownDrawing: -> @_builder.destroy()

  setupEditing: ->
    @_editor = Build.Editor.create
      buildScreenView: @view
      track: @track

  teardownEditing: -> @_editor.destroy()

  setupTesting: ->
    @_car = Shared.Car.create track: @track

    @_testDrive = Shared.BaseGame.create
      screenView: @view
      track: @track
      car: @_car

    @_testDrive.start true # start race immediately

  teardownTesting: ->
    @_car.destroy()
    @_testDrive.destroy()

  setupRasterizing: ->
    @_rasterizer = Build.Rasterizer.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

  startRasterizing: -> @_rasterizer.start()

  teardownRasterizing: -> @_rasterizer.destroy()

  setupPublishing: ->
    @_publisher = Build.Publisher.create
      stateManager: @_buildScreenStateManager
      buildScreenView: @view
      track: @track

  performPublishing: -> @_publisher.publish()

  teardownPublishing: -> @_publisher.destroy()

  destroy: ->
    @_super()
    @_buildScreenStateManager.destroy()
    @track.deleteRecord() if @track? and @track.get 'isDirty'

Shared.ScreenFactory.getInstance().registerScreen 'BuildScreen', Build.BuildScreen
