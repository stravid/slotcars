
#= require slotcars/build/build_screen

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

  it 'should send build screen state manager to Drawing state', ->
    (expect @BuildScreenStateManagerMock.goToState).toHaveBeenCalledWith 'Drawing'

  describe 'destroy', ->

    beforeEach ->
      @BuildScreenStateManagerMock.destroy = sinon.spy()
      @buildScreen.prepareDrawing() # creates Builder

    it 'should destroy the build screen state manager', ->
      @buildScreen.destroy()

      (expect @BuildScreenStateManagerMock.destroy).toHaveBeenCalled()

  describe 'prepare for drawing', ->

    it 'should create the builder and provide build screen view and track', ->
      @buildScreen.prepareDrawing()

      (expect @builderMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @BuildScreenStateManagerMock
        buildScreenView: @buildScreenViewMock
        track: @fakeTrack

  describe 'cleaning up drawing', ->

    it 'should tell the builder to destroy itself', ->
      @buildScreen.prepareDrawing()
      @builderMock.destroy = sinon.spy()
      @buildScreen.teardownDrawing()

      (expect @builderMock.destroy).toHaveBeenCalled()

  describe 'prepare for test drive', ->

    beforeEach ->
      @testDriveMock.start = sinon.spy()

    it 'should create the test drive and provide dependencies', ->
      @buildScreen.prepareTesting()

      (expect @testDriveMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @BuildScreenStateManagerMock
        buildScreenView: @buildScreenViewMock
        track: @fakeTrack

    it 'should start the test drive', ->
      @buildScreen.prepareTesting()

      (expect @testDriveMock.start).toHaveBeenCalled()

  describe 'cleaning up test drive', ->

    beforeEach ->
      @testDriveMock.start = sinon.spy()
      @buildScreen.prepareTesting() # creates TestDrive

    it 'should tell the test drive to destroy itself', ->
      @testDriveMock.destroy = sinon.spy()
      @buildScreen.teardownTesting()

      (expect @testDriveMock.destroy).toHaveBeenCalled()
