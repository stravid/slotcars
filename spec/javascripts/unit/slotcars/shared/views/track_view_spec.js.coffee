
#= require slotcars/shared/views/track_view
#= require slotcars/play/controllers/game_controller

describe 'track view', ->

  TrackView = slotcars.shared.views.TrackView
  GameController = slotcars.play.controllers.GameController

  beforeEach ->
    @raphaelBackup = window.Raphael
    @raphaelElementStub = sinon.stub().returns attr: ->
    @paperClearSpy = sinon.spy()

    @raphaelStub = window.Raphael = sinon.stub().returns
      path: @raphaelElementStub
      rect: @raphaelElementStub
      clear: @paperClearSpy

    @gameControllerMock = mockEmberClass GameController

    @trackView = TrackView.create
      gameController: @gameControllerMock

    @trackView.appendTo '<div>'

    Ember.run.end()

  afterEach ->
    window.Raphael = @raphaelBackup
    @gameControllerMock.restore()

  it 'should be a subclass of ember view', ->
    (expect TrackView).toExtend Ember.View

  it 'should have an element id', ->
    trackView = TrackView.create()
    (expect trackView.get 'elementId').toBe 'track-view'

  it 'should create raphael paper view is appended to DOM', ->
    (expect @raphaelStub).toHaveBeenCalledWith @trackView.$()[0], 1024, 768

  describe 'drawing the track', ->

    it 'should not ignore drawing if not inserted in DOM', ->
      trackView = TrackView.create()

      (expect trackView.drawTrack).not.toThrow()

    it 'should clear the paper before drawing', ->
      @trackView.drawTrack('M0,0Z')

      (expect @paperClearSpy).toHaveBeenCalled()
