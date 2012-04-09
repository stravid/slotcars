
#= require slotcars/play/game
#= require slotcars/play/controllers/game_controller

#= require slotcars/shared/models/car
#= require slotcars/shared/models/track

#= require slotcars/play/views/car_view
#= require slotcars/play/views/game_view
#= require slotcars/shared/views/track_view
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/views/clock_view

describe 'game', ->

  Game = slotcars.play.Game
  Car = slotcars.shared.models.Car
  Track = slotcars.shared.models.Track
  CarView = slotcars.play.views.CarView
  GameController = slotcars.play.controllers.GameController
  GameView = slotcars.play.views.GameView
  TrackView = slotcars.shared.views.TrackView
  PlayTrackView = slotcars.play.views.PlayTrackView
  PlayScreenView = slotcars.play.views.PlayScreenView
  ClockView = slotcars.play.views.ClockView

  beforeEach ->
    @carMock = mockEmberClass Car
    @trackMock = mockEmberClass Track
    @playScreenViewMock = mockEmberClass PlayScreenView, set: sinon.spy()

    @GameControllerMock = mockEmberClass GameController
    @CarViewMock = mockEmberClass CarView
    @GameViewMock = mockEmberClass GameView
    @PlayTrackViewMock = mockEmberClass PlayTrackView
    @ClockViewMock = mockEmberClass ClockView

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
    @PlayTrackViewMock.restore()
    @ClockViewMock.restore()


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
      (expect @PlayTrackViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @GameControllerMock, track: @trackMock

    it 'should append car view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

    it 'should append track view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'contentView', @PlayTrackViewMock

    it 'should append game view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'gameView', @GameViewMock

    it 'should append clock view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'clockView', @ClockViewMock


  describe 'starting the game', ->

    beforeEach ->
      @GameControllerMock.start = sinon.spy()
      @trackMock.raphaelPath = {}
      @trackMock.getPointAtLength = sinon.stub().returns x: 3, y: 4

    it 'should start the game controller', ->
      @game.start()

      (expect @GameControllerMock.start).toHaveBeenCalled()

  describe 'destroying the game', ->

    it 'should call destroy on the game controller', ->
      @GameControllerMock.destroy = sinon.spy()
      @game.destroy()

      (expect @GameControllerMock.destroy).toHaveBeenCalled()
