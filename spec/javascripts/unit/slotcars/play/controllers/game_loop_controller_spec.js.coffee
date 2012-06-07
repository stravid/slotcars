describe 'Play.GameLoopController (unit)', ->

  beforeEach ->
    @requestAnimationFrameBackup = window.requestAnimationFrame
    @requestAnimationFrameStub = window.requestAnimationFrame = sinon.spy()

    @gameLoop = Play.GameLoopController.create()

  afterEach ->
    window.requestAnimationFrame = @requestAnimationFrameBackup

  describe '#start', ->

    it 'should call renderCallback when first started', ->
      renderCallbackSpy = sinon.spy()
      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalled()

    it 'should set the stop loop flag to false', ->
      @gameLoop.set 'stopLoop', true
      @gameLoop.start ->

      (expect @gameLoop.get 'stopLoop').toBe false

    it 'should use requestFrame for running the loop', ->
      @gameLoop.start ->

      (expect @requestAnimationFrameStub).toHaveBeenCalled()

    it 'should call renderCallback for each requested frame', ->
      renderCallbackSpy = sinon.spy()
      maxTestFrameCount = 3
      frameCount = 0

      requestAnimationFrameStub = window.requestAnimationFrame = (loopCallback) ->
        frameCount++

        if frameCount < maxTestFrameCount
          loopCallback()

      @gameLoop.start renderCallbackSpy

      (expect renderCallbackSpy).toHaveBeenCalledThrice()

    it 'should stop the loop if the stop loop flag is set', ->
      count = 0
      callback = -> count++

      @gameLoop.start callback

      numberOfCalls = count
      @gameLoop.set 'stopLoop', true

      (expect count).toEqual numberOfCalls

  describe '#destroy', ->

    it 'should set the stop loop flag to true', ->
      @gameLoop.destroy()

      (expect @gameLoop.get 'stopLoop').toBe true
