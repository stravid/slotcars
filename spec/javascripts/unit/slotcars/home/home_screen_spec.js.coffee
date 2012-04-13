
#= require slotcars/home/home_screen
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory
#= require slotcars/factories/widget_factory

describe 'home screen', ->

  HomeScreen = slotcars.home.HomeScreen
  HomeScreenView = slotcars.home.views.HomeScreenView
  ScreenFactory = slotcars.factories.ScreenFactory
  Appendable = slotcars.shared.lib.Appendable
  Container = Slotcars.shared.components.Container
  WidgetFactory = Slotcars.factories.WidgetFactory

  beforeEach ->
    @accountWidgetMock = addToContainerAtLocation: sinon.spy()
    @widgetFactoryMock = getInstanceOf: sinon.stub().withArgs('AccountWidget').returns @accountWidgetMock
    @widgetFactoryGetInstanceStub = (sinon.stub WidgetFactory, 'getInstance').returns @widgetFactoryMock

    @homeScreenViewMock = mockEmberClass HomeScreenView
    @homeScreen = HomeScreen.create()

  afterEach ->
    @homeScreenViewMock.restore()
    @widgetFactoryGetInstanceStub.restore()

  it 'should be appendable', ->
    (expect @homeScreen).toExtend Appendable

  it 'should be a widget container', ->
    (expect @homeScreen).toExtend Container

  it 'should register itself at the screen factory', ->
    homeScreen = ScreenFactory.getInstance().getInstanceOf 'HomeScreen'

    (expect homeScreen).toBeInstanceOf HomeScreen

  it 'should create home screen view', ->
    (expect @homeScreenViewMock.create).toHaveBeenCalled()

  it 'should add the account widget to its right column when created', ->
    (expect @accountWidgetMock.addToContainerAtLocation).toHaveBeenCalledWith @homeScreen, 'rightColumn'