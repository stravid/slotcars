
#= require game/controllers/game_application
#= require game/controllers/game_controller
#= require game/mediators/game_mediator
#= require game/views/track

describe 'game.controllers.GameController (unit)', ->

  GameController = game.controllers.GameController
  GameMediator = game.mediators.GameMediator

  beforeEach ->
    @gameController = GameController.create
      rootElement: document.createElement 'div'
      mediator: GameMediator.create()

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect GameController).toBe true

  it 'should have a property startTime with default null', ->
    (expect @gameController.startTime).toBe null

  it 'should have a property endTime with default null', ->
    (expect @gameController.endTime).toBe null

  it 'should have a property raceTime with default null', ->
    (expect @gameController.raceTime).toBe null

  it 'should set isTouchMouseDown to false by default', ->
    gameController = GameController.create()
    (expect gameController.isTouchMouseDown).toBe false


  describe '#onTouchMouseDown', ->

    it 'should set isTouchMouseDown to true', ->
      gameController = GameController.create()

      gameController.onTouchMouseDown()

      (expect gameController.isTouchMouseDown).toBe true

    it 'should be called when touchMouseDown is triggered on document', ->
      gameController = GameController.create()

      ($ document).trigger 'touchMouseDown'

      (expect gameController.isTouchMouseDown).toBe true

  describe '#onTouchMouseUp', ->

    it 'should set isTouchMouseDown to false', ->
      gameController = GameController.create()

      gameController.onTouchMouseUp()

      (expect gameController.isTouchMouseDown).toBe false


    it 'should be called when touchMouseUp is triggered on document', ->
      gameController = GameController.create
        isTouchMouseDown: true

      ($ document).trigger 'touchMouseUp'

      (expect gameController.isTouchMouseDown).toBe false


  describe '#update', ->

    beforeEach ->
      @carController = game.controllers.CarController.create()

      @accelerateStub = sinon.stub @carController, 'accelerate'
      @slowDownStub = sinon.stub @carController, 'slowDown'
      @driveStub = sinon.stub @carController, 'drive'

      @gameController = GameController.create
        carController: @carController

    afterEach ->
      @carController.accelerate.restore()
      @carController.drive.restore()
      @carController.slowDown.restore()

    it 'should accelerate car when isTouchMouseDown is true', ->
      @gameController.isTouchMouseDown = true

      @gameController.update()

      (expect @accelerateStub).toHaveBeenCalledOnce()

    it 'should slowDown when isTouchMouseDown is false', ->
      @gameController.isTouchMouseDown = false

      @gameController.update()

      (expect @accelerateStub).not.toHaveBeenCalled()
      (expect @slowDownStub).toHaveBeenCalledOnce()

    it 'should drive car', ->
      @gameController.update()

      (expect @driveStub).toHaveBeenCalledOnce()


  describe '#start', ->
      
    it 'should save timestamp', ->
      gameController = GameController.create
        gameLoopController: 
          start: ->
        update: ->      

      gameController.start()
      (expect gameController.startTime).toNotBe null

    it 'should reset race time to null', ->
      gameController = GameController.create
        gameLoopController: 
          start: ->
        update: ->

      gameController.start()
      (expect gameController.raceTime).toBe null

    it 'should start the game loop with #update method as renderCallback', ->
      @maxCalls = Math.floor(Math.random(1) * 10) + 5
      timesCalled = 0

      @gameLoopControllerStub =
        maxCalls: @maxCalls
        start: (renderCallback) ->
          renderCallback()
          timesCalled++

          if timesCalled < @maxCalls
            @start renderCallback

      @gameControllerUpdateStub = sinon.spy()

      @gameController = GameController.create
        gameLoopController: @gameLoopControllerStub
        update: @gameControllerUpdateStub

      @gameController.start()
      (expect @gameControllerUpdateStub.callCount).toBe @maxCalls


  describe '#finish', ->
      
    it 'should save timestamp', ->
      @gameController.finish()
      (expect @gameController.endTime).toNotBe null
    
    it 'should calculate and update race time', ->
      @gameController.finish()
      (expect @gameController.raceTime).toNotBe null
        
