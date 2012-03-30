
#= require slotcars/tracks/tracks_screen
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view
#= require slotcars/factories/screen_factory

describe 'tracks screen', ->

  TracksScreen = slotcars.tracks.TracksScreen
  TracksController = slotcars.tracks.controllers.TracksController
  TracksScreenView = slotcars.tracks.views.TracksScreenView
  ScreenFactory = slotcars.factories.ScreenFactory

  beforeEach ->
    @TracksControllerMock = mockEmberClass TracksController
    @TracksScreenViewMock = mockEmberClass TracksScreenView,
      append: sinon.spy()

    @tracksScreen = TracksScreen.create()

  afterEach ->
    @TracksControllerMock.restore()
    @TracksScreenViewMock.restore()


  it 'should register itself at the screen factory', ->
    tracksScreen = ScreenFactory.getInstance().getInstanceOf 'TracksScreen'

    (expect tracksScreen).toBeInstanceOf TracksScreen


  describe 'appending tracks screen to application', ->

    beforeEach ->
      @tracksScreen.appendToApplication()

    it 'should create the tracks controller', ->
      (expect @TracksControllerMock.create).toHaveBeenCalled()

    it 'should create the tracks screen view', ->
      (expect @TracksScreenViewMock.create).toHaveBeenCalled()

    it 'should append the tracks screen view', ->
      (expect @TracksScreenViewMock.append).toHaveBeenCalled()

  describe 'destroying', ->

    beforeEach ->
      @TracksScreenViewMock.remove = sinon.spy()
      @tracksScreen.appendToApplication()

    it 'should tell the tracks screen view to remove itself', ->
      @tracksScreen.destroy()
      
      (expect @TracksScreenViewMock.remove).toHaveBeenCalled()