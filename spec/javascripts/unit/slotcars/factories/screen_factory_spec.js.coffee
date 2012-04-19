describe 'screen factory', ->

  ScreenFactory = slotcars.factories.ScreenFactory

  it 'should be a factory', -> (expect ScreenFactory).toExtend Slotcars.factories.Factory


  describe 'registering screens', ->

    beforeEach -> @screenFactory = ScreenFactory.create()

    it 'should provide specific method for registering screens', ->
      registerTypeStub = sinon.stub @screenFactory, 'registerType'
      id = 'TestScreen'
      testScreen = {}

      @screenFactory.registerScreen id, testScreen

      (expect registerTypeStub).toHaveBeenCalledWith id, testScreen