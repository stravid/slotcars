describe 'play screen', ->

  beforeEach ->
    sinon.stub Shared.ModelStore, 'find', -> Shared.Track.createRecord()

    @playScreenViewMock = mockEmberClass Play.PlayScreenView,
      append: sinon.spy()
      remove: sinon.spy()
    @playScreenStateManagerMock = mockEmberClass Play.PlayScreenStateManager, send: sinon.spy()
    @GameMock = mockEmberClass Play.Game,
      start: sinon.spy()
      destroy: sinon.spy()

    @playScreen = Play.PlayScreen.create()

  afterEach ->
    Shared.ModelStore.find.restore()
    @playScreenViewMock.restore()
    @playScreenStateManagerMock.restore()
    @GameMock.restore()

  it 'should create play screen view', ->
    (expect @playScreenViewMock.create).toHaveBeenCalled()

  it 'should register itself at the screen factory', ->
    playScreen = Shared.ScreenFactory.getInstance().getInstanceOf 'PlayScreen'

    (expect playScreen).toBeInstanceOf Play.PlayScreen

  it 'should create the play screen state manager', ->
    (expect @playScreenStateManagerMock.create).toHaveBeenCalled()

  it 'should create the play screen state manager', ->
    (expect @playScreenStateManagerMock.create).toHaveBeenCalled()


  describe 'loading', ->

    it 'should load a track', ->
      @playScreen.load()

      (expect @playScreen.track).toBeInstanceOf Shared.Track

    it 'should create a car', ->
      @playScreen.load()

      (expect @playScreen.car).toBeInstanceOf Shared.Car

    it 'should send loaded to the play screen state manager', ->
      @playScreen.load()

      (expect @playScreenStateManagerMock.send).toHaveBeenCalledWith 'loaded'


  describe 'initializing', ->

    beforeEach ->
      @playScreen.load()
      @playScreen.initialize()

    it 'should create game and provide necessary dependencies', ->
      (expect @GameMock.create).toHaveBeenCalledWithAnObjectLike
        playScreenView: @playScreenViewMock
        track: @playScreen.track
        car: @playScreen.car


  describe 'playing', ->

    beforeEach ->
      @playScreen.load()
      @playScreen.initialize()
      @playScreen.play()

    it 'should start the game', ->
      (expect @GameMock.start).toHaveBeenCalled()

  describe 'destroying', ->

    beforeEach -> @gameStub = destroy: sinon.spy()

    it 'should tell the game to destroy itself', ->
      @playScreen.set '_game', @gameStub
      @playScreen.destroy()

      (expect @gameStub.destroy).toHaveBeenCalled()

    it 'should only destroy the game if it is present', ->
      @playScreen.destroy()

      (expect @gameStub.destroy).not.toHaveBeenCalled()
