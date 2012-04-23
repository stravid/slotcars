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