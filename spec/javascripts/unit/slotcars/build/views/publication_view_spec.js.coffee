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
      @publicationView.onPublishButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedPublishButton'


  describe 'getting the track title from publiction form', ->

    beforeEach ->
      @trackTitleElementStub = val: sinon.stub()
      @publicationView.$ = sinon.stub().returns @trackTitleElementStub

    it 'should get the value of the track title input and return it', ->
      titleInPublicationForm = "muh"
      @trackTitleElementStub.val.returns titleInPublicationForm

      resultingTitle = @publicationView.getTrackTitleFromPublicationForm()

      (expect resultingTitle).toBe titleInPublicationForm