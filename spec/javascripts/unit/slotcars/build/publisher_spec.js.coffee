describe 'Build.Publisher', ->

  beforeEach ->
    @trackMock = Ember.Object.create
      save: sinon.spy()

    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager, send: sinon.spy()
    @buildScreenViewMock = mockEmberClass Build.BuildScreenView, set: sinon.spy()
    @PublicationViewMock = mockEmberClass Build.PublicationView
    @AuthorizationViewMock = mockEmberClass Build.AuthorizationView

  afterEach ->
    @buildScreenStateManagerMock.restore()
    @buildScreenViewMock.restore()
    @PublicationViewMock.restore()
    @AuthorizationViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect Build.Publisher).toExtend Ember.Object

  describe 'no current user present', ->
    
    beforeEach ->
      @publisher = Build.Publisher.create
        stateManager: @buildScreenStateManagerMock
        buildScreenView: @buildScreenViewMock
        track: @trackMock

    it 'should create a authorization view', ->
      (expect @AuthorizationViewMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @buildScreenStateManagerMock
        delegate: @publisher

    it 'should append the authorization view to the build screen view', ->
      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @AuthorizationViewMock

  describe 'current user present', ->

    beforeEach ->
      Shared.User.current = {}

      @publisher = Build.Publisher.create
        stateManager: @buildScreenStateManagerMock
        buildScreenView: @buildScreenViewMock
        track: @trackMock

    it 'should create a publication view', ->
      (expect @PublicationViewMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @buildScreenStateManagerMock
        track: @trackMock

    it 'should append the publication view to the build screen view', ->
      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @PublicationViewMock

    describe 'publishing', ->

      beforeEach ->
        Shared.routeManager = mockEmberClass Shared.RouteManager, set: sinon.spy()
        sinon.stub @publisher, 'setTitleOnTrackToPublish'

      afterEach -> Shared.routeManager.restore()

      it 'should save the track', ->
        @publisher.publish()

        (expect @trackMock.save).toHaveBeenCalled()

      it 'should provide a callback to switch to game mode after track was saved', ->
        @trackId = 30
        @trackMock.set 'id', @trackId

        @publisher.publish()

        publicationCallback = @trackMock.save.args[0][0]
        publicationCallback() # gets normally called by track.save

        (expect Shared.routeManager.set).toHaveBeenCalledWith 'location', "play/#{@trackId}"

      it 'should set the title on the track before saving', ->
        @publisher.publish()

        (expect @publisher.setTitleOnTrackToPublish).toHaveBeenCalledBefore @trackMock.save


    describe 'setting title on track from publication form', ->

      beforeEach ->
        @trackMock.setTitle = sinon.spy()
        @PublicationViewMock.getTrackTitleFromPublicationForm = sinon.stub()

      it 'should get the track title from publication view and set it on track', ->
        testTrackTitle = "muh"
        @PublicationViewMock.getTrackTitleFromPublicationForm.returns testTrackTitle

        @publisher.setTitleOnTrackToPublish()

        (expect @trackMock.setTitle).toHaveBeenCalledWith testTrackTitle