
#= require slotcars/account/widgets/account_widget
#= require slotcars/shared/components/widget
#= require slotcars/shared/components/container

describe 'Slotcars.account.widgets.AccountWidget', ->

  AccountWidget = Slotcars.account.widgets.AccountWidget
  Widget = Slotcars.shared.components.Widget
  Container = Slotcars.shared.components.Container
  WidgetFactory = Slotcars.factories.WidgetFactory
  AccountWidgetView = Slotcars.account.views.AccountWidgetView

  beforeEach ->
    @loginWidgetMock = addToContainerAtLocation: sinon.spy()
    @widgetFactoryMock = getInstanceOf: sinon.stub().withArgs('LoginWidget').returns @loginWidgetMock
    @widgetFactoryGetInstanceStub = (sinon.stub WidgetFactory, 'getInstance').returns @widgetFactoryMock

    @accountWidgetInstance = AccountWidget.create()

  afterEach ->
    @widgetFactoryGetInstanceStub.restore()


  it 'should be a widget', ->
      (expect @accountWidgetInstance).toExtend Widget

  it 'should be a container', ->
    (expect @accountWidgetInstance).toExtend Container

  it 'should create its account widget view', ->
    (expect @accountWidgetInstance.get 'view').toBeInstanceOf AccountWidgetView

  it 'should register itself at widget factory', ->
    @widgetFactoryGetInstanceStub.restore()
    accountWidget = WidgetFactory.getInstance().getInstanceOf 'AccountWidget'

    (expect accountWidget).toBeInstanceOf AccountWidget

  it 'should get and add the login widget at content location by default', ->
    (expect @loginWidgetMock.addToContainerAtLocation).toHaveBeenCalled @accountWidgetInstance, 'content'