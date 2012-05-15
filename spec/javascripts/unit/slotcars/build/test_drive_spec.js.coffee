describe 'test drive', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car
    @trackMock = mockEmberClass Shared.Track
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager

    @BaseGameControllerMock = mockEmberClass Shared.BaseGameController, set: sinon.spy()
    @TrackViewMock = mockEmberClass Shared.TrackView, gameController: {}
    @CarViewMock = mockEmberClass Play.CarView
    @BaseGameViewContainerMock = mockEmberClass Shared.BaseGameViewContainer, set: sinon.spy()

    @buildScreenViewMock = set: sinon.spy()

    @testDrive = Build.TestDrive.create
      buildScreenView: @buildScreenViewMock
      track: @trackMock
      car: @carMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()
    @buildScreenStateManagerMock.restore()
    @BaseGameControllerMock.restore()
    @TrackViewMock.restore()
    @CarViewMock.restore()
    @BaseGameViewContainerMock.restore()

  it 'should extend Ember.Object', ->
    (expect Build.TestDrive).toExtend Ember.Object

  it 'should create a game controller and provide necessary dependencies', ->
    (expect @BaseGameControllerMock.create).toHaveBeenCalledWithAnObjectLike
      track: @trackMock
      car: @carMock

  it 'should enable car controls on game controller', ->
    (expect @BaseGameControllerMock.set).toHaveBeenCalledWith 'carControlsEnabled', true

  it 'should create a car view and provide a car', ->
    (expect @CarViewMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock

  it 'should create a track view and provide dependencies', ->
    (expect @TrackViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @BaseGameControllerMock, track: @trackMock

  it 'should create a test drive view and provide the game controller', ->
    (expect @BaseGameViewContainerMock.create).toHaveBeenCalled()

  it 'should append car view to test drive view', ->
    (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

  it 'should append track view to play screen view', ->
    (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'trackView', @TrackViewMock

  it 'should append car view to test drive view', ->
    (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @BaseGameViewContainerMock

  describe 'starting the game', ->

    beforeEach ->
      @BaseGameControllerMock.start = sinon.spy()

    it 'should start the game controller', ->
      @testDrive.start()

      (expect @BaseGameControllerMock.start).toHaveBeenCalled()

  describe 'destroying the game', ->

    beforeEach ->
      @BaseGameControllerMock.destroy = sinon.spy()
      @CarViewMock.destroy = sinon.spy()
      @TrackViewMock.destroy = sinon.spy()
      @BaseGameViewContainerMock.destroy = sinon.spy()

      @testDrive.destroy()

    it 'should unset the content view on build screen view', ->
      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', null

    it 'should tell the car view to destroy itself', ->
      (expect @CarViewMock.destroy).toHaveBeenCalled()

    it 'should tell the track view to destroy itself', ->
      (expect @TrackViewMock.destroy).toHaveBeenCalled()

    it 'should tell the test drive view to destroy itself', ->
      (expect @BaseGameViewContainerMock.destroy).toHaveBeenCalled()

    it 'should call destroy on the game controller', ->
      (expect @BaseGameControllerMock.destroy).toHaveBeenCalled()
