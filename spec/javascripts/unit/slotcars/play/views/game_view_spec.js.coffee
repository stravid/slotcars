
#= require slotcars/play/views/game_view
#= require slotcars/play/controllers/game_controller

describe 'slotcars.play.views.GameView (unit)', ->

  GameView = slotcars.play.views.GameView
  GameController = slotcars.play.controllers.GameController

  beforeEach ->
    @gameController = GameController.create
      track: Ember.Object.create()  # real track is not necessary here
      car: Ember.Object.create()

    @gameView = GameView.create
      gameController: @gameController

  it 'should extend Ember.View', ->
    (expect GameView).toExtend Ember.View

  it 'should restart game when restartGame event was triggered', ->
    @gameController.restartGame = sinon.spy()
    @gameView.onRestartClick()
    
    (expect @gameController.restartGame).toHaveBeenCalled()
