describe 'screen factory', ->

  it 'should be a factory', ->
    (expect Shared.ScreenFactory).toExtend Shared.Factory

  describe 'registering screens', ->

    beforeEach -> @screenFactory = Shared.ScreenFactory.create()

    it 'should provide specific method for registering screens', ->
      registerTypeStub = sinon.stub @screenFactory, 'registerType'
      id = 'TestScreen'
      testScreen = {}

      @screenFactory.registerScreen id, testScreen

      (expect registerTypeStub).toHaveBeenCalledWith id, testScreen

  describe 'getting instance', ->

    beforeEach ->
      @id = 'TestScreen'
      testScreen = Ember.Object.extend view: null

      @screenFactory = Shared.ScreenFactory.create()
      @screenFactory.registerScreen @id, testScreen

    it 'should apply Appendable mixin on each instance', ->
      screenInstance = @screenFactory.getInstanceOf @id

      (expect screenInstance).toHaveTheFunctionalityOf Shared.Appendable

    it 'should apply Animatable mixin on each instance', ->
      screenInstance = @screenFactory.getInstanceOf @id

      (expect screenInstance).toHaveTheFunctionalityOf Shared.Animatable
