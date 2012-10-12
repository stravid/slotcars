describe 'Shared.BaseGame', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car
    @trackMock = mockEmberClass Shared.Track
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager

    @BaseGameControllerMock = mockEmberClass Shared.BaseGameController
    @TrackViewMock = mockEmberClass Shared.TrackView,
      gameController: {}
      car: @carMock
      scaledOffset: 0 # required
      paperOffset: 0  # required
      scaleFactor: 1  # required

    @CarViewMock = mockEmberClass Play.CarView
    @BaseGameViewContainerMock = mockEmberClass Shared.BaseGameViewContainer, set: sinon.spy()

    @screenViewMock = set: sinon.spy()

    @baseGame = Shared.BaseGame.create
      screenView: @screenViewMock
      track: @trackMock
      car: @carMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()
    @buildScreenStateManagerMock.restore()
    @BaseGameControllerMock.restore()
    @TrackViewMock.restore()
    @CarViewMock.restore()
    @BaseGameViewContainerMock.restore()

  it 'should extend Ember.Object', ->
    (expect Shared.BaseGame).toExtend Ember.Object

  it 'should create a base game controller and provide necessary dependencies', ->
    (expect @BaseGameControllerMock.create).toHaveBeenCalledWithAnObjectLike track: @trackMock, car: @carMock

  it 'should create a car view and provide a car', ->
    (expect @CarViewMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock

  it 'should create a track view and provide dependencies', ->
    (expect @TrackViewMock.create).toHaveBeenCalledWithAnObjectLike
      gameController: @BaseGameControllerMock
      track: @trackMock
      car: @carMock

  it 'should create a view container to append the single views', ->
    (expect @BaseGameViewContainerMock.create).toHaveBeenCalled()

  it 'should append car view to the view container', ->
    (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

  it 'should append track view to the view container', ->
    (expect @BaseGameViewContainerMock.set).toHaveBeenCalledWith 'trackView', @TrackViewMock

  it 'should append the view container to the passed screen view', ->
    (expect @screenViewMock.set).toHaveBeenCalledWith 'contentView', @BaseGameViewContainerMock

  describe 'starting the game', ->

    beforeEach ->
      @BaseGameControllerMock.start = sinon.spy()
      @BaseGameControllerMock.set = sinon.spy()

    it 'should start the game controller', ->
      @baseGame.start()

      (expect @BaseGameControllerMock.start).toHaveBeenCalled()

    it 'should start race immediately if the passed parameter is true', ->
      @baseGame.start true

      (expect @BaseGameControllerMock.set).toHaveBeenCalledWith 'isRaceRunning', true

    it 'should not start race immediately if the passed parameter is false', ->
      @baseGame.start()

      (expect @BaseGameControllerMock.set).not.toHaveBeenCalledWith 'isRaceRunning', true

  describe 'destroying the game', ->

    beforeEach ->
      sinon.spy @BaseGameControllerMock, 'destroy'
      sinon.spy @BaseGameViewContainerMock, 'destroy'
      sinon.spy @TrackViewMock, 'destroy'
      sinon.spy @CarViewMock, 'destroy'

    it 'should unset the content view on build screen view', ->
      @baseGame.destroy()

      (expect @screenViewMock.set).toHaveBeenCalledWith 'contentView', null

    it 'should destroy the base game view container', ->
      @baseGame.destroy()

      (expect @BaseGameViewContainerMock.destroy).toHaveBeenCalled()

    it 'should destroy the game controller', ->
      @baseGame.destroy()

      (expect @BaseGameControllerMock.destroy).toHaveBeenCalled()

    it 'should destroy the car view', ->
      @baseGame.destroy()

      (expect @CarViewMock.destroy).toHaveBeenCalled()

    it 'should destroy the track view', ->
      @baseGame.destroy()

      (expect @TrackViewMock.destroy).toHaveBeenCalled()
