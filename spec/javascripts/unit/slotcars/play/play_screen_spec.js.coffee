
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
    @GameMock = mockEmberClass Game,
      start: sinon.spy()
      destroy: sinon.spy()

    @playScreen = PlayScreen.create()

  afterEach ->
    ModelStore.find.restore()
    @playScreenViewMock.restore()
    @playScreenStateManagerMock.restore()
    @GameMock.restore()


  describe 'append to application', ->

    beforeEach ->
      @playScreen.load = sinon.spy()

    it 'should create the play screen state manager', ->
      @playScreen.appendToApplication()

      (expect @playScreenStateManagerMock.create).toHaveBeenCalled()

    it 'should append the play screen view to the DOM', ->
      @playScreen.appendToApplication()

      (expect @playScreenViewMock.append).toHaveBeenCalled()


  describe 'loading', ->

    beforeEach ->
      @playScreen.appendToApplication()

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
      @playScreen.appendToApplication()
      @playScreen.load()
      @playScreen.initialize()

    it 'should create game and provide necessary dependencies', ->
      (expect @GameMock.create).toHaveBeenCalledWithAnObjectLike
        playScreenView: @playScreenViewMock
        track: @playScreen.track
        car: @playScreen.car


  describe 'playing', ->

    beforeEach ->
      @playScreen.appendToApplication()
      @playScreen.load()
      @playScreen.initialize()
      @playScreen.play()

    it 'should start the game', ->
      (expect @GameMock.start).toHaveBeenCalled()

  describe 'destroying', ->

    beforeEach ->
      @playScreenViewMock.remove = sinon.spy()
      @playScreen.appendToApplication()
      @gameStub =
        destroy: sinon.spy()

    it 'should tell the play screen view to remove itself', ->
      @playScreen.destroy()

      (expect @playScreenViewMock.remove).toHaveBeenCalled()

    it 'should tell the game to destroy itself', ->
      @playScreen.set '_game', @gameStub
      @playScreen.destroy()

      (expect @gameStub.destroy).toHaveBeenCalled()

    it 'should only destroy the game if it is present', ->
      @playScreen.destroy()

      (expect @gameStub.destroy).not.toHaveBeenCalled()