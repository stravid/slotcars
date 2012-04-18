describe 'Build.BuildScreen', ->

  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @buildScreenViewMock = mockEmberClass Build.BuildScreenView,
      remove: sinon.spy()

    @BuildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager, goToState: sinon.spy()

    @TrackBackup = Shared.Track
    @fakeTrack = {}
    @TrackMock = Shared.Track =
      createRecord: sinon.stub().returns @fakeTrack

    @buildScreen = Build.BuildScreen.create()

  afterEach ->
    @buildScreenViewMock.restore()
    @BuildScreenStateManagerMock.restore()
    Shared.Track = @TrackBackup

  it 'should register itself at the screen factory', ->
    buildScreen = ScreenFactory.getInstance().getInstanceOf 'BuildScreen'

    (expect buildScreen).toBeInstanceOf Build.BuildScreen

  it 'should create build screen view', ->
    (expect @buildScreenViewMock.create).toHaveBeenCalledWithAnObjectLike stateManager: @BuildScreenStateManagerMock

  it 'should create a build screen state manager', ->
    (expect @BuildScreenStateManagerMock.create).toHaveBeenCalledWithAnObjectLike delegate: @buildScreen

  it 'should send build screen state manager to Drawing state', ->
    (expect @BuildScreenStateManagerMock.goToState).toHaveBeenCalledWith 'Drawing'

  describe 'destroy', ->

    beforeEach ->
      @BuildScreenStateManagerMock.destroy = sinon.spy()

    it 'should destroy the build screen state manager', ->
      @buildScreen.destroy()

      (expect @BuildScreenStateManagerMock.destroy).toHaveBeenCalled()

  describe 'drawing capabilities', ->

    beforeEach ->
      @builderMock = mockEmberClass Build.Builder

    afterEach ->
      @builderMock.restore()

    describe 'prepare for drawing', ->

      it 'should create a new track model', ->
        @buildScreen.setupDrawing()

        (expect @TrackMock.createRecord).toHaveBeenCalled()

      it 'should create the builder and provide build screen view and track', ->
        @buildScreen.setupDrawing()

        (expect @builderMock.create).toHaveBeenCalledWithAnObjectLike
          stateManager: @BuildScreenStateManagerMock
          buildScreenView: @buildScreenViewMock
          track: @fakeTrack

    describe 'clean up drawing', ->

      beforeEach ->
        @buildScreen.setupDrawing() # creates Builder

      it 'should tell the builder to destroy itself', ->
        @builderMock.destroy = sinon.spy()
        @buildScreen.teardownDrawing()

        (expect @builderMock.destroy).toHaveBeenCalled()

  describe 'test drive capabilities', ->

    beforeEach ->
      @testDriveMock = mockEmberClass Build.TestDrive, start: sinon.spy()
      @buildScreen.track = @fakeTrack # track gets only created in drawing setup - so set it by hand for this test case

    afterEach ->
      @testDriveMock.restore()

    describe 'prepare for test drive', ->

      it 'should create the test drive and provide dependencies', ->
        @buildScreen.setupTesting()

        (expect @testDriveMock.create).toHaveBeenCalledWithAnObjectLike
          stateManager: @BuildScreenStateManagerMock
          buildScreenView: @buildScreenViewMock
          track: @fakeTrack

      it 'should start the test drive', ->
        @buildScreen.setupTesting()

        (expect @testDriveMock.start).toHaveBeenCalled()

    describe 'clean up test drive', ->

      beforeEach ->
        @buildScreen.setupTesting() # creates TestDrive

      it 'should tell the test drive to destroy itself', ->
        @testDriveMock.destroy = sinon.spy()
        @buildScreen.teardownTesting()

        (expect @testDriveMock.destroy).toHaveBeenCalled()

  describe 'rasterization capabilities', ->

    beforeEach ->
      @rasterizerMock = mockEmberClass Build.Rasterizer, start: sinon.spy()
      @buildScreen.track = @fakeTrack # track gets only created in drawing setup - so set it by hand for this test case

    afterEach ->
      @rasterizerMock.restore()

    describe 'prepare rasterization', ->

      it 'should create the rasterizer and provide dependencies', ->
        @buildScreen.setupRasterizing()

        (expect @rasterizerMock.create).toHaveBeenCalledWithAnObjectLike
          stateManager: @BuildScreenStateManagerMock
          buildScreenView: @buildScreenViewMock
          track: @fakeTrack

    describe 'start rasterization', ->

      beforeEach ->
        @buildScreen.setupRasterizing() # creates Rasterizer

      it 'should start the rasterization', ->
        @buildScreen.startRasterizing()

        (expect @rasterizerMock.start).toHaveBeenCalled()

    describe 'clean up rasterization', ->

      beforeEach ->
        @buildScreen.setupRasterizing() # creates Rasterizer

      it 'should tell the rasterizer to destroy itself', ->
        @rasterizerMock.destroy = sinon.spy()
        @buildScreen.teardownRasterizing()

        (expect @rasterizerMock.destroy).toHaveBeenCalled()
