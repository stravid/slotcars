
#= require game/controllers/game_controller
#= require game/mediators/game_mediator
#= require game/views/track_view
#= require game/views/game_view
#= require shared/models/track_model
#= require game/controllers/car_controller


describe 'game.controllers.GameController (unit)', ->

  GameController = game.controllers.GameController
  GameView = game.views.GameView
  TrackModel = shared.models.TrackModel

  beforeEach ->
    @trackStub = sinon.stub()
    @gameController = GameController.create
      track: @trackStub

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect GameController).toBe true

  it 'should set isTouchMouseDown to false by default', ->
    (expect @gameController.isTouchMouseDown).toBe false

  it 'should throw an error when no track is passed', ->
    (expect => GameController.create()).toThrow()

  it 'should create a car', ->
    (expect @gameController.car).not.toBe null


  describe '#onTouchMouseDown', ->

    it 'should set isTouchMouseDown to true', ->
      eventStub = originalEvent: preventDefault: ->

      @gameController.onTouchMouseDown eventStub

      (expect @gameController.isTouchMouseDown).toBe true

    it 'should be called when isTouchMouseDown is triggered on document', ->

      # necessary to trigger 'mousedown' because of 'originalEvent' property which is added through event normalization
      (jQuery document).trigger 'mousedown'

      (expect @gameController.isTouchMouseDown).toBe true

  describe '#onTouchMouseUp', ->

    it 'should set isTouchMouseDown to false', ->
      eventStub = originalEvent:
          preventDefault: ->

      @gameController.onTouchMouseUp eventStub

      (expect @gameController.isTouchMouseDown).toBe false


    it 'should be called when touchMouseUp is triggered on document', ->
      @gameController.isTouchMouseDown = true

      # necessary to trigger 'mouseup' because of 'originalEvent' property which is added through event normalization
      (jQuery document).trigger 'mouseup'

      (expect @gameController.isTouchMouseDown).toBe false


  # describe '#update', ->
  # 
  #   beforeEach ->
  #     @carController = game.controllers.CarController.create()
  # 
  #     @accelerateStub = sinon.stub @carController, 'accelerate'
  #     @slowDownStub = sinon.stub @carController, 'slowDown'
  #     @driveStub = sinon.stub @carController, 'drive'
  # 
  #     @gameController.carController = @carController
  # 
  #   afterEach ->
  #     @carController.accelerate.restore()
  #     @carController.drive.restore()
  #     @carController.slowDown.restore()
  # 
  #   it 'should accelerate car when isTouchMouseDown is true', ->
  #     @gameController.isTouchMouseDown = true
  # 
  #     @gameController.update()
  # 
  #     (expect @accelerateStub).toHaveBeenCalledOnce()
  # 
  #   it 'should slowDown when isTouchMouseDown is false', ->
  #     @gameController.isTouchMouseDown = false
  # 
  #     @gameController.update()
  # 
  #     (expect @accelerateStub).not.toHaveBeenCalled()
  #     (expect @slowDownStub).toHaveBeenCalledOnce()
  # 
  #   it 'should drive car', ->
  #     @gameController.update()
  # 
  #     (expect @driveStub).toHaveBeenCalledOnce()


  describe '#start', ->

    beforeEach ->
      @carControllerStub =
        setup: sinon.spy()

      path = helpers.math.Path.create points: [
        {x: 10, y:10, angle: 0}
        {x: 20, y:50, angle: 0}
        {x: 30, y:50, angle: 0}
      ]

      @trackStub = TrackModel.createRecord()
      @trackStub.setPointPath path

      @gameController = GameController.create
        track: @trackStub
        gameLoopController:
          start: ->
        update: ->
        carController: @carControllerStub

    it 'should save timestamp', ->
      @gameController.start()
      (expect @gameController.startTime).toNotBe null

    it 'should start the game loop with #update method as renderCallback', ->
      @gameLoopControllerStub =
        start: (renderCallback) ->
          renderCallback()

      @gameControllerUpdateStub = sinon.spy()

      @gameController.gameLoopController = @gameLoopControllerStub
      @gameController.update = @gameControllerUpdateStub

      @gameController.start()

      (expect @gameControllerUpdateStub).toHaveBeenCalled()

    it 'should set car to startposition', ->
      @gameController.start()
      (expect @gameController.car.get 'position').toEqual { x: 10, y: 10 }


  describe '#finish', ->
      
    it 'should save timestamp', ->
      @gameController.finish()
      (expect @gameController.endTime).toNotBe null
    
    it 'should calculate and update race time', ->
      @gameController.finish()
      (expect @gameController.raceTime).toNotBe null
      
    it 'should call finish when crossFinishLine event was triggered in CarController', ->
      carControllerStub = {}
      finishSpy = sinon.spy()
      
      gameController = GameController.create
        track: @trackStub
        carController: carControllerStub
        finish: finishSpy
      
      (jQuery carControllerStub).trigger 'crossFinishLine'
      (expect finishSpy).toHaveBeenCalled()


  describe '#restartGame', ->

    beforeEach ->
      @carResetSpy = sinon.spy()
      @carControllerStub = 
        reset: @carResetSpy

      @stopGameLoopSpy = sinon.spy()
      @gameLoopControllerStub =
        stop: @stopGameLoopSpy
        start: ->


    it 'should call restartGame when restartGame event was triggered', ->
      restartGameSpy = sinon.spy()

      gameController = GameController.create
        track: @trackStub
        gameView: GameView.create()
        restartGame: restartGameSpy
  
      (jQuery gameController.gameView).trigger 'restartGame'
      (expect restartGameSpy).toHaveBeenCalledOnce()

    it 'should reset raceTime', ->
      gameController = GameController.create
        track: @trackStub
        carController: @carControllerStub        
        gameLoopController: @gameLoopControllerStub

      gameController.gameMediator.raceTime = 18
      gameController.restartGame()

      (expect gameController.gameMediator.raceTime).toBe 0

    it 'should reset car', ->
      gameController = GameController.create
        track: @trackStub
        carController: @carControllerStub
        gameLoopController: @gameLoopControllerStub

      gameController.restartGame()
      (expect @carResetSpy).toHaveBeenCalled()
