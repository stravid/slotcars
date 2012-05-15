describe 'game', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car
    @trackMock = mockEmberClass Shared.Track
    @playScreenViewMock = mockEmberClass Play.PlayScreenView, set: sinon.spy()

    @GameControllerMock = mockEmberClass Play.GameController
    @CarViewMock = mockEmberClass Play.CarView
    @GameViewMock = mockEmberClass Play.GameView
    @PlayTrackViewMock = mockEmberClass Play.PlayTrackView,
      gameController: {}  # gameController is required by Controllable mixin which is used here
    @ClockViewMock = mockEmberClass Play.ClockView
    @BaseGameViewContainerMock = mockEmberClass Shared.BaseGameViewContainer, set: sinon.spy()

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
    @BaseGameViewContainerMock.restore()


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

    it 'should append car view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'trackView', @PlayTrackViewMock

    it 'should append car view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

    it 'should append game view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'gameView', @GameViewMock

    it 'should append clock view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'clockView', @ClockViewMock

    it 'should append track view to play screen view', ->
      (expect @playScreenViewMock.set).toHaveBeenCalledWith 'contentView', @BaseGameViewContainerMock


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
