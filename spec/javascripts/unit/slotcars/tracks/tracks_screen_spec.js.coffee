describe 'tracks screen', ->

  beforeEach ->
    @TracksControllerMock = mockEmberClass Tracks.TracksController
    @TracksScreenViewMock = mockEmberClass Tracks.TracksScreenView,
      append: sinon.spy()

    @tracksScreen = Tracks.TracksScreen.create()

  afterEach ->
    @TracksControllerMock.restore()
    @TracksScreenViewMock.restore()


  it 'should register itself at the screen factory', ->
    tracksScreen = Shared.ScreenFactory.getInstance().getInstanceOf 'TracksScreen'

    (expect tracksScreen).toBeInstanceOf Tracks.TracksScreen


  it 'should create tracks screen view', ->
    (expect @TracksScreenViewMock.create).toHaveBeenCalled()

  it 'should create the tracks controller and provide view', ->
    (expect @TracksControllerMock.create).toHaveBeenCalledWithAnObjectLike tracksScreenView: @TracksScreenViewMock

