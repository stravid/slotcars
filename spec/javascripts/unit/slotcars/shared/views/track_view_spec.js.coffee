
#= require slotcars/shared/views/track_view

describe 'track view', ->

  TrackView = slotcars.shared.views.TrackView

  it 'should be a subclass of ember view', ->
    (expect TrackView).toExtend Ember.View

  it 'should have an element id', ->
    trackView = TrackView.create()
    (expect trackView.get 'elementId').toBe 'track-view'

  describe 'drawing the track', ->

    beforeEach ->
      @raphaelBackup = window.Raphael
      raphaelElementStub = attr: ->
      @raphaelStub = window.Raphael = sinon.stub().returns
        path: -> raphaelElementStub
        rect: -> raphaelElementStub

    afterEach ->
      window.Raphael = @raphaelBackup

    it 'should not ignore drawing if track is null', ->
      trackView = TrackView.create()

      (expect trackView.drawTrack).not.toThrow()

    it 'should create raphael paper when drawing track the first time', ->
      @trackView = TrackView.create track: get: ->
      @trackView.appendTo '<div>'

      Ember.run.end()

      @trackView.drawTrack()

      (expect @raphaelStub).toHaveBeenCalledWith @trackView.$()[0], 1024, 768