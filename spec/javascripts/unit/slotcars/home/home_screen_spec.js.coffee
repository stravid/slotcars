describe 'home screen', ->

  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @homeScreenViewMock = mockEmberClass Home.HomeScreenView
    @homeScreen = Home.HomeScreen.create()

  afterEach ->
    @homeScreenViewMock.restore()


  it 'should register itself at the screen factory', ->
    homeScreen = ScreenFactory.getInstance().getInstanceOf 'HomeScreen'

    (expect homeScreen).toBeInstanceOf Home.HomeScreen

  it 'should create home screen view', ->
    (expect @homeScreenViewMock.create).toHaveBeenCalled()
