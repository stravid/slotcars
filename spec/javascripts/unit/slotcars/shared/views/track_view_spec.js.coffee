describe 'track view', ->

  TrackView = slotcars.shared.views.TrackView

  beforeEach ->
    @raphaelBackup = window.Raphael
    @raphaelElementStub = sinon.stub().returns
      attr: ->
      transform: ->
    @paperClearSpy = sinon.spy()

    @raphaelStub = window.Raphael = sinon.stub().returns
      path: @raphaelElementStub
      rect: @raphaelElementStub
      clear: @paperClearSpy

    @gameControllerMock = mockEmberClass Play.GameController

    @trackView = TrackView.create
      gameController: @gameControllerMock

    @trackView.appendTo '<div>'
    Ember.run.end()

  afterEach ->
    window.Raphael = @raphaelBackup
    @gameControllerMock.restore()

  it 'should be a subclass of ember view', ->
    (expect TrackView).toExtend Ember.View

  describe 'appendeding view to DOM', ->

    it 'should create raphael paper', ->
      @trackView.didInsertElement()

      (expect @raphaelStub).toHaveBeenCalledWith @trackView.$()[0], 1024 * @trackView.scaleFactor, 768 * @trackView.scaleFactor

    it 'should mime a change of the raphaelPath on the track', ->
      sinon.spy @trackView, 'onTrackChange'
      @trackView.didInsertElement()

      (expect @trackView.onTrackChange).toHaveBeenCalled()

  describe 'drawing the track', ->

    it 'should not ignore drawing if not inserted in DOM', ->
      trackView = TrackView.create()

      (expect trackView.drawTrack).not.toThrow()

    it 'should clear the paper before drawing', ->
      @trackView.drawTrack('M0,0Z')

      (expect @paperClearSpy).toHaveBeenCalled()
