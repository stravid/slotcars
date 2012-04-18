describe 'home screen', ->

  HomeScreen = slotcars.home.HomeScreen
  HomeScreenView = slotcars.home.views.HomeScreenView
  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @homeScreenViewMock = mockEmberClass HomeScreenView
    @homeScreen = HomeScreen.create()

  afterEach ->
    @homeScreenViewMock.restore()


  it 'should register itself at the screen factory', ->
    homeScreen = ScreenFactory.getInstance().getInstanceOf 'HomeScreen'

    (expect homeScreen).toBeInstanceOf HomeScreen

  it 'should create home screen view', ->
    (expect @homeScreenViewMock.create).toHaveBeenCalled()
