describe 'Play.ResultView (unit)', ->
  
  beforeEach ->
    @gameControllerMock = mockEmberClass Play.GameController,
      isRaceFinished: false
    
    @resultView = Play.ResultView.create
      gameController: @gameControllerMock
  
  afterEach ->
    @gameControllerMock.restore()
    
  it 'should update the race time when it changes in controller', ->
    @resultView.onRaceTimeChange = sinon.spy()
    @gameControllerMock.set 'raceTime', 123
    
    (expect @resultView.onRaceTimeChange).toHaveBeenCalled()