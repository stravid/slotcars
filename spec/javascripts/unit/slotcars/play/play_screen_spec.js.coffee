
#= require slotcars/play/play_screen
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track_model
#= require slotcars/play/game

describe 'play screen', ->

  PlayScreen = slotcars.play.PlayScreen
  PlayScreenView = slotcars.play.views.PlayScreenView
  PlayScreenStateManager = slotcars.play.PlayScreenStateManager
  TrackModel = slotcars.shared.models.TrackModel
  Car = slotcars.shared.models.Car
  Game = slotcars.play.Game

  beforeEach ->
    @playScreenViewMock = mockEmberClass PlayScreenView, append: sinon.spy()
    @playScreenStateManagerMock = mockEmberClass PlayScreenStateManager, send: sinon.spy()
    @GameMock = mockEmberClass Game, start: sinon.spy()
    @playScreen = PlayScreen.create()

  afterEach ->
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

  describe 'load', ->

    beforeEach ->
      @playScreen.appendToApplication()

    it 'should load a track', ->
      @playScreen.load()

      (expect @playScreen.track).toBeInstanceOf TrackModel

    it 'should create a car', ->
      @playScreen.load()

      (expect @playScreen.car).toBeInstanceOf Car

    it 'should send loaded to the play screen state manager', ->
      @playScreen.load()

      (expect @playScreenStateManagerMock.send).toHaveBeenCalledWith 'loaded'

  describe 'initialize', ->

    beforeEach ->
      @playScreen.appendToApplication()
      @playScreen.load()
      @playScreen.initialize()

    it 'should create game and provide necessary dependencies', ->
      (expect @GameMock.create).toHaveBeenCalledWithAnObjectLike
        playScreenView: @playScreenViewMock
        track: @playScreen.track
        car: @playScreen.car

    it 'should send initialized to the play screen state manager', ->
      (expect @playScreenStateManagerMock.send).toHaveBeenCalledWith 'initialized'

  describe 'play', ->

    beforeEach ->
      @playScreen.appendToApplication()
      @playScreen.load()
      @playScreen.initialize()
      @playScreen.play()

    it 'should start the game', ->
      (expect @GameMock.start).toHaveBeenCalled()

  describe 'destroy', ->

    beforeEach ->
      @playScreenViewMock.remove = sinon.spy()
      @playScreen.appendToApplication()

    it 'should tell the play screen view to remove itself', ->
      @playScreen.destroy()

      (expect @playScreenViewMock.remove).toHaveBeenCalled()