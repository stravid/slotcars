
#= require slotcars/play/play_screen
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track
#= require slotcars/play/game
#= require slotcars/shared/models/model_store

describe 'play screen', ->

  PlayScreen = slotcars.play.PlayScreen
  PlayScreenView = slotcars.play.views.PlayScreenView
  PlayScreenStateManager = slotcars.play.PlayScreenStateManager
  Track = slotcars.shared.models.Track
  Car = slotcars.shared.models.Car
  Game = slotcars.play.Game
  ModelStore = slotcars.shared.models.ModelStore

  beforeEach ->
    sinon.stub ModelStore, 'find', -> Track.createRecord()

    @playScreenViewMock = mockEmberClass PlayScreenView, append: sinon.spy()
    @playScreenStateManagerMock = mockEmberClass PlayScreenStateManager, send: sinon.spy()
    @GameMock = mockEmberClass Game, start: sinon.spy()
    @playScreen = PlayScreen.create()

  afterEach ->
    ModelStore.find.restore()
    @playScreenViewMock.restore()
    @playScreenStateManagerMock.restore()
    @GameMock.restore()

  it 'should create play screen view', ->
    (expect @playScreenViewMock.create).toHaveBeenCalled()

  it 'should create the play screen state manager', ->
    (expect @playScreenStateManagerMock.create).toHaveBeenCalled()

  describe 'loading', ->

    it 'should load a track', ->
      @playScreen.load()

      (expect @playScreen.track).toBeInstanceOf Track

    it 'should create a car', ->
      @playScreen.load()

      (expect @playScreen.car).toBeInstanceOf Car

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
