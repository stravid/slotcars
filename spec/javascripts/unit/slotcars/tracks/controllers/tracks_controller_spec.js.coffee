describe 'Tracks.TracksController', ->

  beforeEach ->
    @trackBackup = Shared.Track
    Shared.Track = find: sinon.spy(), count: sinon.spy()
    @TracksViewMock = mockEmberClass Tracks.TracksView
    @TracksScreenViewMock = mockEmberClass Tracks.TracksScreenView

    @tracksController = Tracks.TracksController.create
      tracksScreenView: @TracksScreenViewMock

  afterEach ->
    Shared.Track = @trackBackup
    @TracksViewMock.restore()
    @TracksScreenViewMock.restore()

  describe 'creation', ->

    it 'should create a tracks view', ->
      (expect @TracksViewMock.create).toHaveBeenCalled()

    it 'should count the tracks', ->
      (expect Shared.Track.count).toHaveBeenCalled()

    it 'should load tracks for the current and next page', ->
      (expect Shared.Track.find).toHaveBeenCalledTwice()

    it 'should set the content view of the tracks screen view', ->
      Ember.run.next => (expect @TracksScreenViewMock.set).toHaveBeenCalledWith 'contentView', @TracksViewMock

  describe '#destroy', ->

    it 'should destroy the tracks view', ->
      sinon.spy @TracksViewMock, 'destroy'

      @tracksController.destroy()

      (expect @TracksViewMock.destroy).toHaveBeenCalled()
