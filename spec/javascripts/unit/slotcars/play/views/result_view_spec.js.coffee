
#= require slotcars/play/views/result_view
#= require slotcars/play/controllers/game_controller

describe 'slotcars.play.views.ResultView (unit)', ->
  
  ResultView = slotcars.play.views.ResultView
  GameController = slotcars.play.controllers.GameController
  
  # beforeEach ->
  #   @gameControllerMock = mockEmberClass GameController,
  #     isRaceFinished: false
    
  #   @resultView = ResultView.create
  #     gameController: @gameControllerMock
  
  # afterEach ->
  #   @gameControllerMock.restore()
  
  # it 'should listen to the controller wether the race is over or not', ->
  #   # @resultView.onRaceStatusChange = sinon.spy()
  #   # @gameControllerMock.set 'isRaceFinished', true

  #   (expect @resultView.onRaceStatusChange).toHaveBeenCalled()
