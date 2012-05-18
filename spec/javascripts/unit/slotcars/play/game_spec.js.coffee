describe 'Play.Game', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car
    @trackMock = mockEmberClass Shared.Track
    @screenViewMock = set: sinon.spy()

    @GameControllerMock = mockEmberClass Play.GameController
    @TrackViewMock = mockEmberClass Shared.TrackView,
      gameController: {}
      track: @trackMock
      car: @carMock

    @CarViewMock = mockEmberClass Play.CarView
    @GameViewMock = mockEmberClass Play.GameView
    @ClockViewMock = mockEmberClass Play.ClockView
    @BaseGameViewContainerMock = mockEmberClass Shared.BaseGameViewContainer, set: sinon.spy()

    @game = Play.Game.create
      screenView: @screenViewMock
      track: @trackMock
      car: @carMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()
    @GameControllerMock.restore()
    @TrackViewMock.restore()
    @CarViewMock.restore()
    @GameViewMock.restore()
    @ClockViewMock.restore()
    @BaseGameViewContainerMock.restore()

  describe 'creating the game', ->

    it 'should extend Shared.BaseGame', ->
      (expect Play.Game).toExtend Shared.BaseGame

    it 'should create a game controller and provide necessary dependencies', ->
      (expect @GameControllerMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock, track: @trackMock

    it 'should create a game view and provide a game controller', ->
      (expect @GameViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @GameControllerMock

    it 'should append game view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'gameView', @GameViewMock

    it 'should append clock view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'clockView', @ClockViewMock

  describe 'destroying the game', ->

    beforeEach ->
      @ClockViewMock.destroy = sinon.spy()
      @GameViewMock.destroy = sinon.spy()
      @GameControllerMock.destroy = sinon.spy()

      @game.destroy()

    it 'should call destroy on the clock view', ->
      (expect @ClockViewMock.destroy).toHaveBeenCalled()

    it 'should call destroy on the game view', ->
      (expect @GameViewMock.destroy).toHaveBeenCalled()
