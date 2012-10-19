describe 'Play.Game', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car
    @trackMock = mockEmberClass Shared.Track
    @screenViewMock = set: sinon.spy()

    @GameControllerMock = mockEmberClass Play.GameController,
      isRaceFinished: false
      raceTime: null
      car: @carMock

    @TrackViewMock = mockEmberClass Shared.TrackView,
      gameController: {}
      track: @trackMock
      car: @carMock
      scaledOffset: 0 # required
      paperOffset: 0  # required
      scaleFactor: 1  # required

    @CarViewMock = mockEmberClass Play.CarView
    @GameViewMock = mockEmberClass Play.GameView
    @ClockViewMock = mockEmberClass Play.ClockView
    @GhostViewMock = mockEmberClass Play.GhostView
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
    @GhostViewMock.restore()
    @BaseGameViewContainerMock.restore()

  describe 'creating the game', ->

    it 'should extend Shared.BaseGame', ->
      (expect Play.Game).toExtend Shared.BaseGame

    it 'should create a game controller and provide necessary dependencies', ->
      (expect @GameControllerMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock, track: @trackMock

    it 'should create a game view and provide a game controller', ->
      (expect @GameViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @GameControllerMock

    it 'should create a clock view and provide necessary dependencies', ->
      (expect @ClockViewMock.create).toHaveBeenCalledWithAnObjectLike
        gameController: @GameControllerMock
        car: @carMock
        track: @trackMock

    it 'should create a ghost view', ->
      (expect @GhostViewMock.create).toHaveBeenCalled()

    it 'should append game view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'gameView', @GameViewMock

    it 'should append clock view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'clockView', @ClockViewMock

    it 'should append ghost view to base game view container', ->
      (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'ghostView', @GhostViewMock

  describe 'destroying the game', ->

    beforeEach ->
      sinon.spy @GameControllerMock, 'destroy'
      sinon.spy @GhostViewMock, 'destroy'
      sinon.spy @GameViewMock, 'destroy'
      sinon.spy @ClockViewMock, 'destroy'

      @game.destroy()

    it 'should destroy the game controller', ->
      (expect @GameControllerMock.destroy).toHaveBeenCalled()

    it 'should destroy the ghost view', ->
      (expect @GhostViewMock.destroy).toHaveBeenCalled()

    it 'should destroy the clock view', ->
      (expect @ClockViewMock.destroy).toHaveBeenCalled()

    it 'should destroy the game view', ->
      (expect @GameViewMock.destroy).toHaveBeenCalled()
