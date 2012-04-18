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


  it 'should create tracks screen view', ->
    (expect @TracksScreenViewMock.create).toHaveBeenCalled()

  it 'should create the tracks controller and provide view', ->
    (expect @TracksControllerMock.create).toHaveBeenCalledWithAnObjectLike tracksScreenView: @TracksScreenViewMock

