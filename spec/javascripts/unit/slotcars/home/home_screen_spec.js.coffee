
#= require slotcars/home/home_screen
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory

describe 'home screen', ->

  HomeScreen = slotcars.home.HomeScreen
  HomeScreenView = slotcars.home.views.HomeScreenView
  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @homeScreenViewMock = mockEmberClass HomeScreenView, append: sinon.spy()
    @homeScreen = HomeScreen.create()

  afterEach ->
    @homeScreenViewMock.restore()


  it 'should register itself at the screen factory', ->
    homeScreen = ScreenFactory.get().getInstanceOf 'HomeScreen'

    (expect homeScreen).toBeInstanceOf HomeScreen


  describe 'append to application', ->

    it 'should append the home screen view to the DOM body', ->
      @homeScreen.appendToApplication()

      (expect @homeScreenViewMock.append).toHaveBeenCalled()

  describe 'destroy', ->

    beforeEach ->
      @homeScreenViewMock.remove = sinon.spy()
      @homeScreen.appendToApplication()

    it 'should tell the home screen view to remove itself', ->
      @homeScreen.destroy()

      (expect @homeScreenViewMock.remove).toHaveBeenCalled()