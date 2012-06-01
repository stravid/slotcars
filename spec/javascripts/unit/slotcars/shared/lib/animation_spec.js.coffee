describe 'Shared.Animation', ->

  beforeEach ->
    @animationFunction = sinon.spy()
    @callbackFunction = sinon.spy()

    @animation = Shared.Animation.create
      fn: @animationFunction
      callback: @callbackFunction

  describe 'running the animation', ->

    beforeEach -> @emberRunLaterStub = sinon.stub(Ember.run, 'later').yields()
    afterEach -> @emberRunLaterStub.restore()

    it 'should run the animation after a delay', ->
      @animation.run()

      (expect @animationFunction).toHaveBeenCalled()

    it 'should run the callback after the animation finished', ->
      @animation.run()

      (expect @callbackFunction).toHaveBeenCalled()

    it 'should return an instance of its class', ->
      returnValue = @animation.run()

      (expect returnValue).toEqual @animation
