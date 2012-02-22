
#= require game/controllers/game_loop_controller

describe 'game.controllers.GameLoopController (unit)', ->

  GameLoopController = game.controllers.GameLoopController

  describe '#start', ->

    beforeEach ->
      @requestFrameBackup = window.requestFrame
      @requestFrameStub = window.requestFrame = sinon.spy()

      @gameLoop = GameLoopController.create()

    afterEach ->
      window.requestFrame = @requestFrameBackup

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
