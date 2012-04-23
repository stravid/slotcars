describe 'Shared.WidgetFactory', ->

  it 'should be a factory', -> (expect Shared.WidgetFactory).toExtend Shared.Factory

  describe 'registering widgets', ->

      beforeEach -> @widgetFactory = Shared.WidgetFactory.create()

      it 'should provide specific method for registering widgets', ->
        registerTypeStub = sinon.stub @widgetFactory, 'registerType'
        id = 'TestWidget'
        testWidget = {}

        @widgetFactory.registerWidget id, testWidget

        (expect registerTypeStub).toHaveBeenCalledWith id, testWidget