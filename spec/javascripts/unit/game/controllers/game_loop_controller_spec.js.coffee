
#= require game/controllers/game_loop_controller

describe 'game.controllers.GameLoopController', ->

  GameLoopController = game.controllers.GameLoopController

  describe '#start', ->

    beforeEach ->
      @requestAnimationFrameBackup = window.webkitRequestAnimationFrame
      @requestAnmiationFrameStub = window.webkitRequestAnimationFrame = sinon.spy()

      @gameLoop = GameLoopController.create()

    afterEach ->
      window.webkitRequestAnimationFrame = @requestAnimationFrameBackup

    it 'should call renderCallback when first started', ->
      renderCallbackSpy = sinon.spy()
      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalled()

    it 'should use requestAnimationFrame for running the loop', ->
      @gameLoop.start ->

      (expect @requestAnmiationFrameStub).toHaveBeenCalled()

    it 'should call renderCallback for each requested frame', ->
      renderCallbackSpy = sinon.spy()
      maxTestFrameCount = 3
      frameCount = 0

      requestAnmiationFrameStub = window.webkitRequestAnimationFrame = (loopCallback) ->
        frameCount++

        if frameCount < maxTestFrameCount
          loopCallback()

      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalledThrice()
