
#= require slotcars/shared/views/track_view

describe 'track view', ->

  TrackView = slotcars.shared.views.TrackView

  beforeEach ->
      @raphaelBackup = window.Raphael
      @raphaelElementStub = sinon.stub().returns attr: ->
      @paperClearSpy = sinon.spy()

      @raphaelStub = window.Raphael = sinon.stub().returns
        path: @raphaelElementStub
        rect: @raphaelElementStub
        clear: @paperClearSpy

      @trackView = TrackView.create()
      @trackView.appendTo '<div>'

      Ember.run.end()

  afterEach ->
    window.Raphael = @raphaelBackup


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


