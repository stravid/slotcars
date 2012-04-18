describe 'slotcars.play.views.GameView (unit)', ->

  GameView = slotcars.play.views.GameView
  ResultView = slotcars.play.views.ResultView
  GameController = slotcars.play.controllers.GameController

  beforeEach ->
    @resultViewMock = mockEmberClass ResultView
    @gameControllerMock = mockEmberClass GameController

    @gameView = GameView.create
      gameController: @gameControllerMock
        
  afterEach ->
    @resultViewMock.restore()
    @gameControllerMock.restore()

  it 'should extend Ember.View', ->
    (expect GameView).toExtend Ember.View

  it 'should restart game when button was clicked', ->
    @gameControllerMock.restartGame = sinon.spy()
    @gameView.onRestartClick()
    
    (expect @gameControllerMock.restartGame).toHaveBeenCalled()

  it 'should update race time when it changes', ->
    timeValue = 28
    @gameControllerMock.set 'raceTime', timeValue

    (expect @gameView.get 'raceTimeInSeconds').toBe @gameView.convertMillisecondsToSeconds timeValue

  describe 'when race finishes', ->

    beforeEach ->
      @gameControllerMock.set 'isRaceFinished', true

    it 'should create a result view and provide the game controller', ->
      @gameView.onRaceStatusChange()

      (expect @resultViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @gameControllerMock

    it 'should use the dynamic view to insert result view', ->
      @gameView.onRaceStatusChange()

      (expect @gameView.get 'overlayView').toEqual ResultView.create()
