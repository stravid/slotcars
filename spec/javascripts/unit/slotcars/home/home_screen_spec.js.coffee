
#= require slotcars/home/home_screen
#= require slotcars/home/views/home_screen_view

describe 'home screen', ->

  HomeScreen = slotcars.home.HomeScreen
  HomeScreenView = slotcars.home.views.HomeScreenView

  beforeEach ->
    @homeScreenViewMock = mockEmberClass HomeScreenView, append: sinon.spy()
    @homeScreen = HomeScreen.create()

  afterEach ->
    @homeScreenViewMock.restore()

  describe 'append to application', ->

    beforeEach ->
      @homeScreen.appendView = sinon.spy()

    it 'should call appendView method on itself', ->
      @homeScreen.appendToApplication()

      (expect @homeScreen.appendView).toHaveBeenCalled()
