describe 'Build.PublicationView', ->

  beforeEach ->
    @trackMock = {}
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager, send: sinon.spy()

    @publicationView = Build.PublicationView.create
      track: @trackMock
      stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()

  it 'should extend TrackView', ->
    (expect Build.PublicationView).toExtend Shared.TrackView

  describe 'clicking on cancel button', ->

    it 'should inform state manager about cancel button being clicked', ->
      @publicationView.onCancelButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedCancelButton'

  describe 'clicking on publish button', ->

    it 'should inform state manager about publish button being clicked', ->
      @publicationView.submit()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedPublishButton'
