
#= require slotcars/play/views/lap_time_view
#= require slotcars/play/controllers/game_controller

describe 'slotcars.play.views.LapTimeView (unit)', ->
  
  LapTimeView = slotcars.play.views.LapTimeView
  GameController = slotcars.play.controllers.GameController
  
  beforeEach ->
    @gameControllerMock = mockEmberClass GameController
    @gameControllerMock.set 'isRaceFinished', false
    
    @lapTimeView = LapTimeView.create
      gameController: @gameControllerMock
  
  afterEach ->
    @gameControllerMock.restore()
  
  it 'should listen to the controller wether the game is over or not', ->
    @gameControllerMock.set 'isRaceFinished', true
    (expect @lapTimeView.onRaceStatusChange).toHaveBeenCalled()