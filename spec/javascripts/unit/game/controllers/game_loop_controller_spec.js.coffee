
#= require game/controllers/game_loop_controller

describe 'game.controllers.GameLoopController (unit)', ->

  GameLoopController = game.controllers.GameLoopController

  beforeEach ->
    @requestFrameBackup = window.requestFrame
    @requestFrameStub = window.requestFrame = sinon.spy()

    @gameLoop = GameLoopController.create()

  afterEach ->
    window.requestFrame = @requestFrameBackup

  describe '#start', ->

    it 'should call renderCallback when first started', ->
      renderCallbackSpy = sinon.spy()
      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalled()

    it 'should use requestFrame for running the loop', ->
      @gameLoop.start ->

      (expect @requestFrameStub).toHaveBeenCalled()

    it 'should call renderCallback for each requested frame', ->
      renderCallbackSpy = sinon.spy()
      maxTestFrameCount = 3
      frameCount = 0

      requestFrameStub = window.requestFrame = (loopCallback) ->
        frameCount++

        if frameCount < maxTestFrameCount
          loopCallback()

      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalledThrice()

    it 'should set isRunning to true', ->
      @gameLoop.isRunning = false
      @gameLoop.start ->

      (expect @gameLoop.isRunning).toBe true

    it 'should not call renderCallback when isRunning is false', ->
      renderCallbackSpy = sinon.spy()
      maxTestFrameCount = 3
      frameCount = 0
      gameLoop = GameLoopController.create()
 
      requestFrameStub = window.requestFrame = (loopCallback) ->
        frameCount++
        gameLoop.stop()
        
        if frameCount < maxTestFrameCount
          loopCallback()

      gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalledOnce()


  describe '#stop', ->

    it 'should set isRunning to false', ->
      @gameLoop.isRunning = true
      @gameLoop.stop()

      (expect @gameLoop.isRunning).toBe false
