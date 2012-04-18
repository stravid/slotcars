
#= require slotcars/build/views/publication_view
#= require slotcars/build/build_screen_state_manager

describe 'publication view', ->

  TrackView = slotcars.shared.views.TrackView
  PublicationView = Slotcars.build.views.PublicationView
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  beforeEach ->
    @trackMock = {}
    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, send: sinon.spy()

    @publicationView = PublicationView.create
      track: @trackMock
      stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()

  it 'should extend TrackView', ->
    (expect PublicationView).toExtend TrackView

  describe 'clicking on cancel button', ->

    it 'should inform state manager about cancel button being clicked', ->
      @publicationView.onCancelButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedCancelButton'

  describe 'clicking on publish button', ->

    it 'should inform state manager about publish button being clicked', ->
      @publicationView.onPublishButtonClicked()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'clickedPublishButton'
