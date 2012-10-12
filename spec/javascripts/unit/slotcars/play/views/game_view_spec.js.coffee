describe 'Play.GameView (unit)', ->

  beforeEach ->
    @resultViewMock = mockEmberClass Play.ResultView
    @gameControllerMock = mockEmberClass Play.GameController

    @gameView = Play.GameView.create
      gameController: @gameControllerMock

  afterEach ->
    @resultViewMock.restore()
    @gameControllerMock.restore()

  it 'should extend Ember.View', ->
    (expect Play.GameView).toExtend Ember.View

  it 'should restart game when button was clicked', ->
    @gameControllerMock.restartGame = sinon.spy()

    @gameView.onRestartClick()

    (expect @gameControllerMock.restartGame).toHaveBeenCalled()

  it 'should send a message to the route manager when quickplay button was clicked', ->
    Shared.routeManager = mockEmberClass Shared.RouteManager, send: sinon.spy()

    @gameView.onQuickplayClick()

    (expect Shared.routeManager.send).toHaveBeenCalledWith 'quickplay'

    Shared.routeManager.restore()

  describe 'when race finishes', ->

    beforeEach ->
      @gameControllerMock.set 'isRaceFinished', true

    it 'should create a result view and provide the game controller', ->
      @gameView.onRaceStatusChange()

      (expect @resultViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @gameControllerMock

    it 'should use the dynamic view to insert result view', ->
      @gameView.onRaceStatusChange()

      (expect @gameView.get 'overlayView').toEqual Play.ResultView.create()
