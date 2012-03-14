
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

  it 'should restart game when button was clicked', ->
    @gameController.restartGame = sinon.spy()
    @gameView.onRestartClick()
    
    (expect @gameController.restartGame).toHaveBeenCalled()

  it 'should update race time when it changes', ->
    timeValue = 28
    @gameController.set 'raceTime', timeValue

    (expect @gameView.get 'raceTimeInSeconds').toBe @gameView.convertMillisecondsToSeconds timeValue

  it 'should start countdown', ->
    @gameController.set 'countdownInSeconds', 6
    fakeTimer = sinon.useFakeTimers()

    # (expect @gameView.get 'countdown').toBe 6

    fakeTimer.tick 1010
    # (expect @gameView.get 'countdown').toBe @gameController.countdownInSeconds - 1
    fakeTimer.restore()
