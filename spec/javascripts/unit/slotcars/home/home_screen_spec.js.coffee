
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