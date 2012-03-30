
#= require slotcars/factories/factory
#= require slotcars/factories/widget_factory

describe 'Slotcars.factories.WidgetFactory', ->

  Factory = Slotcars.factories.Factory
  WidgetFactory = Slotcars.factories.WidgetFactory

  it 'should be a factory', -> (expect WidgetFactory).toExtend Factory


  describe 'registering widgets', ->

      beforeEach -> @widgetFactory = WidgetFactory.create()

      it 'should provide specific method for registering widgets', ->
        registerTypeStub = sinon.stub @widgetFactory, 'registerType'
        id = 'TestWidget'
        testWidget = {}

        @widgetFactory.registerWidget id, testWidget

        (expect registerTypeStub).toHaveBeenCalledWith id, testWidget