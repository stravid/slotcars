describe 'track view', ->

  beforeEach ->
    @raphaelBackup = window.Raphael

    @paperElementAttrSpy = sinon.spy()

    @raphaelElementStub = sinon.stub().returns
      attr: @paperElementAttrSpy
      transform: ->

    @paperStub =
      path: @raphaelElementStub
      rect: @raphaelElementStub
      clear: sinon.spy()

    @raphaelStub = window.Raphael = sinon.stub().returns @paperStub

    @trackMock = mockEmberClass Shared.Track

    @trackView = Shared.TrackView.create
      track: @trackMock

  afterEach ->
    window.Raphael = @raphaelBackup
    @trackMock.restore()

  it 'should be a subclass of ember view', ->
    (expect Shared.TrackView).toExtend Ember.View

  describe 'appendeding view to DOM', ->

    it 'should create raphael paper', ->
      @trackView.didInsertElement()

      (expect @raphaelStub).toHaveBeenCalledWith @trackView.$()[0], 1024 * @trackView.scaleFactor, 768 * @trackView.scaleFactor

    it 'should draw the track', ->
      raphaelPath = "M0,0R1,0z"
      sinon.stub(@trackMock, 'get').withArgs('raphaelPath').returns raphaelPath
      sinon.spy @trackView, 'drawTrack'

      @trackView.didInsertElement()

      (expect @trackView.drawTrack).toHaveBeenCalledWith raphaelPath

  describe 'drawing the track', ->

    it 'should not ignore drawing if not inserted in DOM', ->
      trackView = Shared.TrackView.create()

      (expect trackView.drawTrack).not.toThrow()

  describe 'updating the track', ->

    beforeEach ->
      @raphaelPath = "M0,0R1,0z"
      sinon.stub(@trackMock, 'get').withArgs('raphaelPath').returns @raphaelPath

      @trackView.didInsertElement() # paper gets created + track is drawn

    it 'should update when raphael path changes on track', ->
      sinon.spy @trackView, 'updateTrack'

      @trackMock.set 'raphaelPath', @raphaelPath

      (expect @trackView.updateTrack).toHaveBeenCalledWith @raphaelPath

    it 'should update raphael elements on the paper', ->
      @trackView.updateTrack @raphaelPath

      (expect @paperElementAttrSpy).toHaveBeenCalledWith 'path', @raphaelPath

  describe 'destroying', ->

    beforeEach ->
      @raphaelPath = "M0,0R1,0z"
      sinon.stub(@trackMock, 'get').withArgs('raphaelPath').returns @raphaelPath

      @trackView.didInsertElement() # paper gets created + track is drawn

    it 'should clear the paper', ->
      @trackView.destroy()

      (expect @paperStub.clear).toHaveBeenCalled()
