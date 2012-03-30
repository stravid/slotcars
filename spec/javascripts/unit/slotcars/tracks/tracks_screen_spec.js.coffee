
#= require slotcars/tracks/tracks_screen
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view

describe 'tracks screen', ->

  TracksScreen = slotcars.tracks.TracksScreen
  TracksController = slotcars.tracks.controllers.TracksController
  TracksScreenView = slotcars.tracks.views.TracksScreenView

  beforeEach ->
    @TracksControllerMock = mockEmberClass TracksController
    @TracksScreenViewMock = mockEmberClass TracksScreenView,
      append: sinon.spy()

    @tracksScreen = TracksScreen.create()

  afterEach ->
    @TracksControllerMock.restore()
    @TracksScreenViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect TracksScreen).toExtend Ember.Object

  it 'should create tracks screen view', ->
    (expect @TracksScreenViewMock.create).toHaveBeenCalled()

  it 'should create the tracks controller and provide view', ->
    (expect @TracksControllerMock.create).toHaveBeenCalledWithAnObjectLike tracksScreenView: @TracksScreenViewMock

