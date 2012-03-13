
#= require slotcars/play/game
#= require slotcars/play/controllers/game_controller

#= require slotcars/shared/models/car
#= require slotcars/shared/models/track

#= require slotcars/play/views/car_view
#= require slotcars/play/views/game_view
#= require slotcars/shared/views/track_view
#= require slotcars/play/views/play_screen_view

describe 'game', ->

  Game = slotcars.play.Game
  Car = slotcars.shared.models.Car
  Track = slotcars.shared.models.Track
  CarView = slotcars.play.views.CarView
  GameController = slotcars.play.controllers.GameController
  GameView = slotcars.play.views.GameView
  TrackView = slotcars.shared.views.TrackView
  PlayScreenView = slotcars.play.views.PlayScreenView

  beforeEach ->
    @carMock = mockEmberClass Car
    @trackMock = mockEmberClass Track
    @playScreenViewMock = mockEmberClass PlayScreenView, set: sinon.spy()

    @GameControllerMock = mockEmberClass GameController
    @CarViewMock = mockEmberClass CarView
    @GameViewMock = mockEmberClass GameView
    @TrackViewMock = mockEmberClass TrackView

    @game = Game.create
      playScreenView: @playScreenViewMock
      track: @trackMock
      car: @carMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()
    @playScreenViewMock.restore()
    @CarViewMock.restore()
    @GameControllerMock.restore()
    @GameViewMock.restore()
    @TrackViewMock.restore()


  describe 'creating the game', ->

    it 'should extend Ember.Object', ->
      (expect Game).toExtend Ember.Object

    it 'should create a car view and provide the car', ->
      (expect @CarViewMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock

    it 'should create a game controller and provide necessary dependencies', ->
      (expect @GameControllerMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock, track: @trackMock

    it 'should create a game view and provide a game controller', ->
      (expect @GameViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @GameControllerMock

    it 'should create a track view', ->
      (expect @TrackViewMock.create).toHaveBeenCalledWithAnObjectLike

    it 'should append car view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

    it 'should append track view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'trackView', @TrackViewMock

    it 'should append game view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'contentView', @GameViewMock


  describe 'starting the game', ->

    beforeEach ->
      @GameControllerMock.start = sinon.spy()
      @TrackViewMock.drawTrack = sinon.spy()
      @trackMock.raphaelPath = {}

    it 'should start the game controller', ->
      @game.start()

      (expect @GameControllerMock.start).toHaveBeenCalled()

    it 'should tell the track view to draw itself', ->
      @game.start()

      (expect @TrackViewMock.drawTrack).toHaveBeenCalledWith @trackMock.raphaelPath
