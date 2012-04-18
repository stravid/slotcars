describe 'game', ->

  Car = slotcars.shared.models.Car
  Track = slotcars.shared.models.Track
  TrackView = slotcars.shared.views.TrackView

  beforeEach ->
    @carMock = mockEmberClass Car
    @trackMock = mockEmberClass Track
    @playScreenViewMock = mockEmberClass Play.PlayScreenView, set: sinon.spy()

    @GameControllerMock = mockEmberClass Play.GameController
    @CarViewMock = mockEmberClass Play.CarView
    @GameViewMock = mockEmberClass Play.GameView
    @PlayTrackViewMock = mockEmberClass Play.PlayTrackView,
      gameController: {}  # gameController is required by Controllable mixin which is used here
    @ClockViewMock = mockEmberClass Play.ClockView

    @game = Play.Game.create
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
      (expect Play.Game).toExtend Ember.Object

    it 'should create a car view and provide the car', ->
      (expect @CarViewMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock

    it 'should create a game controller and provide necessary dependencies', ->
      (expect @GameControllerMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock, track: @trackMock

    it 'should create a track view', ->
      (expect @PlayTrackViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @GameControllerMock, track: @trackMock

    it 'should create a game view and provide a game controller', ->
      (expect @GameViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @GameControllerMock

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

    it 'should start the game controller', ->
      @game.start()

      (expect @GameControllerMock.start).toHaveBeenCalled()

  describe 'destroying the game', ->

    beforeEach ->
      @GameControllerMock.destroy = sinon.spy()

    it 'should call destroy on the game controller', ->
      @game.destroy()

      (expect @GameControllerMock.destroy).toHaveBeenCalled()
