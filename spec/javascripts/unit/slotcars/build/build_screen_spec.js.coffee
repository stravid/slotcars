
#= require slotcars/build/build_screen
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder
#= require slotcars/build/test_drive
#= require slotcars/shared/models/track
#= require slotcars/shared/models/car
#= require slotcars/build/build_screen_state_manager
#= require slotcars/factories/screen_factory

describe 'slotcars.build.BuildScreen', ->

  BuildScreen = slotcars.build.BuildScreen
  Builder = slotcars.build.Builder
  TestDrive = Slotcars.build.TestDrive
  Track = slotcars.shared.models.Track
  Car = slotcars.shared.models.Car
  ScreenFactory = slotcars.factories.ScreenFactory
  BuildScreenView = slotcars.build.views.BuildScreenView
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  beforeEach ->
    @buildScreenViewMock = mockEmberClass BuildScreenView,
      append: sinon.spy()
      remove: sinon.spy()

    @BuildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, goToState: sinon.spy()

    @builderMock = mockEmberClass Builder
    @testDriveMock = mockEmberClass TestDrive

    @TrackBackup = slotcars.shared.models.Track

    @fakeTrack = {}
    @TrackMock = slotcars.shared.models.Track =
      createRecord: sinon.stub().returns @fakeTrack

    @buildScreen = BuildScreen.create()

  afterEach ->
    @buildScreenViewMock.restore()
    @BuildScreenStateManagerMock.restore()
    @builderMock.restore()
    @testDriveMock.restore()
    slotcars.shared.models.Track = @TrackBackup

  it 'should register itself at the screen factory', ->
    buildScreen = ScreenFactory.getInstance().getInstanceOf 'BuildScreen'

    (expect buildScreen).toBeInstanceOf BuildScreen

  it 'should create a new track model', ->
    (expect @TrackMock.createRecord).toHaveBeenCalled()

  it 'should create build screen view', ->
    (expect @buildScreenViewMock.create).toHaveBeenCalled()

  it 'should create a build screen state manager', ->
    (expect @BuildScreenStateManagerMock.create).toHaveBeenCalledWithAnObjectLike delegate: @buildScreen

  describe 'destroy', ->

    beforeEach ->
      @BuildScreenStateManagerMock.destroy = sinon.spy()

      @buildScreen.prepareDrawing() # builder gets created in here

    it 'should destroy the build screen state manager', ->
      @buildScreen.destroy()

      (expect @BuildScreenStateManagerMock.destroy).toHaveBeenCalled()

  describe 'prepare for drawing', ->

    it 'should create the builder and provide build screen view and track', ->
      @buildScreen.prepareDrawing()

      (expect @builderMock.create).toHaveBeenCalledWithAnObjectLike
        buildScreenView: @buildScreenViewMock
        track: @fakeTrack
        stateManager: @BuildScreenStateManagerMock

  describe 'cleaning up drawing', ->

    it 'should tell the builder to destroy itself', ->
      @buildScreen.prepareDrawing()
      @builderMock.destroy = sinon.spy()
      @buildScreen.teardownDrawing()

      (expect @builderMock.destroy).toHaveBeenCalled()

  describe 'prepare for test drive', ->

    beforeEach ->
      @carMock = mockEmberClass Car,
        track: {}

    afterEach ->
      @carMock.restore()

    it 'should create a car', ->
      @buildScreen.prepareTesting()

      (expect @carMock.create).toHaveBeenCalled()

    it 'should create the test drive and provide build screen view', ->
      @buildScreen.prepareTesting()

      (expect @testDriveMock.create).toHaveBeenCalledWithAnObjectLike
        buildScreenView: @buildScreenViewMock
        track: @fakeTrack
        car: @carMock

  describe 'cleaning up test drive', ->

    beforeEach ->
      @carMock = mockEmberClass Car,
        track: {}

      @buildScreen.prepareTesting()

    afterEach ->
      @carMock.restore()

    it 'should tell the car to destroy itself', ->
      @carMock.destroy = sinon.spy()
      @buildScreen.teardownTesting()

      (expect @carMock.destroy).toHaveBeenCalled()

    it 'should tell the test drive to destroy itself', ->
      @testDriveMock.destroy = sinon.spy()
      @buildScreen.teardownTesting()

      (expect @testDriveMock.destroy).toHaveBeenCalled()
