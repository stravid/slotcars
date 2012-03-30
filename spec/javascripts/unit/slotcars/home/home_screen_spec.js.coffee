
#= require slotcars/home/home_screen
#= require slotcars/home/views/home_screen_view

describe 'home screen', ->

  HomeScreen = slotcars.home.HomeScreen
  HomeScreenView = slotcars.home.views.HomeScreenView

  beforeEach ->
    @homeScreenViewMock = mockEmberClass HomeScreenView
    @homeScreen = HomeScreen.create()

  afterEach ->
    @homeScreenViewMock.restore()

  it 'should create home screen view', ->
    (expect @homeScreenViewMock.create).toHaveBeenCalled()
