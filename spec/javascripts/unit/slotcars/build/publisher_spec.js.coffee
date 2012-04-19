
#= require slotcars/build/publisher

describe 'publisher', ->

  Publisher = Slotcars.build.Publisher
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager
  BuildScreenView = slotcars.build.views.BuildScreenView
  PublicationView = Slotcars.build.views.PublicationView

  beforeEach ->
    @trackMock = Ember.Object.create
      save: sinon.spy()

    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, send: sinon.spy()
    @buildScreenViewMock = mockEmberClass BuildScreenView, set: sinon.spy()
    @PublicationViewMock = mockEmberClass PublicationView

    @publisher = Publisher.create
      stateManager: @buildScreenStateManagerMock
      buildScreenView: @buildScreenViewMock
      track: @trackMock

  afterEach ->
    @buildScreenStateManagerMock.restore()
    @buildScreenViewMock.restore()
    @PublicationViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect Publisher).toExtend Ember.Object

  it 'should create a rastrization view and provide the track', ->
    (expect @PublicationViewMock.create).toHaveBeenCalledWithAnObjectLike stateManager: @buildScreenStateManagerMock, track: @trackMock

  it 'should append rasterization view to build screen view view', ->
    (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @PublicationViewMock

  describe 'publishing', ->

    beforeEach ->
      slotcars.routeManager = mockEmberClass slotcars.RouteManager, set: sinon.spy()

    afterEach ->
      slotcars.routeManager.restore()

    it 'should save the track', ->
      @publisher.publish()

      (expect @trackMock.save).toHaveBeenCalled()

    it 'should provide a callback to switch to game mode after track was saved', ->
      @trackId = 30
      @trackMock.set 'id', @trackId

      @publisher.publish()

      publicationCallback = @trackMock.save.args[0][0]
      publicationCallback() # gets normally called by track.save

      (expect slotcars.routeManager.set).toHaveBeenCalledWith 'location', "play/#{@trackId}"

  describe 'destroying', ->

    it 'should unset the content view on build screen view', ->
      @publisher.destroy()

      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', null

    it 'should destroy the rasterization view', ->
      @PublicationViewMock.destroy = sinon.spy()
      @publisher.destroy()

      (expect @PublicationViewMock.destroy).toHaveBeenCalled()
