describe 'play screen', ->

  beforeEach ->
    @trackInstance = Shared.Track._create isLoaded: true
    sinon.stub(Shared.Track, 'find').returns @trackInstance

    Shared.routeManager = mockEmberClass Shared.RouteManager, updateLocation: sinon.spy()

    @carMock = mockEmberClass Shared.Car
    @playScreenViewMock = mockEmberClass Play.PlayScreenView, append: sinon.spy(), $: sinon.spy()
    @playScreenStateManagerMock = mockEmberClass Play.PlayScreenStateManager, send: sinon.spy()
    @GameMock = mockEmberClass Play.Game,
      start: sinon.spy()
      destroy: sinon.spy()

    @playScreenNotificationsControllerMock = mockEmberClass Play.PlayScreenNotificationsController,
      on: sinon.stub()

    @playScreenNotificationsViewMock = mockEmberClass Play.PlayScreenNotificationsView,
      appendTo: sinon.stub()

  afterEach ->
    Shared.Track.find.restore()
    Shared.routeManager.restore()
    @carMock.restore()
    @playScreenViewMock.restore()
    @playScreenNotificationsControllerMock.restore()
    @playScreenNotificationsViewMock.restore()
    @playScreenStateManagerMock.restore()
    @GameMock.restore()

  it 'should register itself at the screen factory', ->
    playScreen = Shared.ScreenFactory.getInstance().getInstanceOf 'PlayScreen'

    (expect playScreen).toBeInstanceOf Play.PlayScreen


  describe 'creating', ->

    it 'should create play screen view', ->
      @playScreen = Play.PlayScreen.create trackId: 1

      (expect @playScreenViewMock.create).toHaveBeenCalled()

    it 'should create the play screen state manager', ->
      @playScreen = Play.PlayScreen.create trackId: 1

      (expect @playScreenStateManagerMock.create).toHaveBeenCalled()


  describe 'loading', ->

    describe 'when no track id is passed', ->

      beforeEach ->
        sinon.stub(Shared.Track, 'findRandom').returns @trackInstance
        @playScreen = Play.PlayScreen.create()

      afterEach -> Shared.Track.findRandom.restore()

      it 'should request a random track', ->
        @playScreen.load()

        (expect Shared.Track.findRandom).toHaveBeenCalled()

    describe 'when track id is passed', ->

      beforeEach -> @playScreen = Play.PlayScreen.create trackId: 1

      it 'should load a track', ->
        @playScreen.load()

        (expect @playScreen.track).toBeInstanceOf Shared.Track

      it 'should create a car', ->
        @playScreen.load()

        (expect @carMock.create).toHaveBeenCalled()

    describe 'when track is already loaded', ->
      beforeEach ->
        @playScreen = Play.PlayScreen.create trackId: 1
        # 'isLoaded' is 'true' on the track instance by default - see top of the page

      it 'should send loaded to the play screen state manager immediatley', ->
        @playScreen.load()

        (expect @playScreenStateManagerMock.send).toHaveBeenCalledWith 'loaded'

      it 'should update the location', ->
        @playScreen.load()

        (expect Shared.routeManager.updateLocation).toHaveBeenCalled()

    describe 'when track not yet loaded', ->
      beforeEach ->
        @playScreen = Play.PlayScreen.create trackId: 1
        @trackInstance.set 'isLoaded', false

      it 'should send loaded to the play screen state manager after the track is loaded', ->
        @playScreen.load()
        @trackInstance.fire 'didLoad' # simulates that the track has been loaded

        (expect @playScreenStateManagerMock.send).toHaveBeenCalledWith 'loaded'

      it 'should update the location after the track is loaded', ->
        @playScreen.load()
        @trackInstance.fire 'didLoad' # simulates that the track has been loaded

        (expect Shared.routeManager.updateLocation).toHaveBeenCalled()

  describe 'initializing', ->

    beforeEach ->
      @testTrackId = 1
      @playScreen = Play.PlayScreen.create trackId: @testTrackId
      @playScreen.load()
      @playScreen.initialize()

    it 'should create game and provide necessary dependencies', ->
      (expect @GameMock.create).toHaveBeenCalledWithAnObjectLike
        screenView: @playScreenViewMock
        track: @playScreen.track
        car: @playScreen.car

    it 'should create the play screen notifications controller', ->
      (expect @playScreenNotificationsControllerMock.create).toHaveBeenCalledWithAnObjectLike
        trackId: @testTrackId

    it 'should create the play screen notifications view', ->
      (expect @playScreenNotificationsViewMock.create).toHaveBeenCalledWithAnObjectLike
        controller: @playScreenNotificationsControllerMock

    it 'should append the play screen notifications view', ->
      (expect @playScreenNotificationsViewMock.appendTo).toHaveBeenCalled()

  describe 'playing', ->

    beforeEach ->
      @playScreen = Play.PlayScreen.create trackId: 1
      @playScreen.load()
      @playScreen.initialize()
      @playScreen.play()

    it 'should start the game', ->
      (expect @GameMock.start).toHaveBeenCalled()

  describe 'destroying', ->

    beforeEach ->
      @carMock.destroy = sinon.spy()
      @GameMock.destroy = sinon.spy()
      @playScreenNotificationsControllerMock.destroy = sinon.spy()
      @playScreenNotificationsViewMock.destroy = sinon.spy()
      @playScreenStateManagerMock.destroy = sinon.spy()

      @playScreen = Play.PlayScreen.create trackId: 1
      @playScreen.car = @carMock
      @playScreen._playScreenStateManager = @playScreenStateManagerMock

    it 'should destroy the play screen state manager', ->
      @playScreen.destroy()

      (expect @playScreenStateManagerMock.destroy).toHaveBeenCalled()

    it 'should destroy the car', ->
      @playScreen.destroy()

      (expect @carMock.destroy).toHaveBeenCalled()

    it 'should tell the game to destroy itself', ->
      @playScreen.set '_game', @GameMock
      @playScreen.destroy()

      (expect @GameMock.destroy).toHaveBeenCalled()

    it 'should only destroy the game if it is present', ->
      @playScreen.destroy()

      (expect @GameMock.destroy).not.toHaveBeenCalled()

    it 'should tell the play screen notifications controller to destroy itself', ->
      @playScreen.set '_playScreenNotificationsController', @playScreenNotificationsControllerMock
      @playScreen.destroy()

      (expect @playScreenNotificationsControllerMock.destroy).toHaveBeenCalled()

    it 'should only destroy the play screen notifications controller if it is present', ->
      @playScreen.destroy()

      (expect @playScreenNotificationsControllerMock.destroy).not.toHaveBeenCalled()

    it 'should tell the play screen notifications view to destroy itself', ->
      @playScreen.set '_playScreenNotificationsView', @playScreenNotificationsViewMock
      @playScreen.destroy()

      (expect @playScreenNotificationsViewMock.destroy).toHaveBeenCalled()

    it 'should only destroy the play screen notifications view if it is present', ->
      @playScreen.destroy()

      (expect @playScreenNotificationsViewMock.destroy).not.toHaveBeenCalled()
