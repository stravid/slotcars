
#= require slotcars/shared/views/track_view

describe 'track view', ->

  TrackView = slotcars.shared.views.TrackView

  it 'should be a subclass of ember view', ->
    (expect TrackView).toExtend Ember.View

  it 'should have an element id', ->
    trackView = TrackView.create()
    (expect trackView.get 'elementId').toBe 'track-view'

  describe 'when inserted in DOM', ->

    beforeEach ->
      @raphaelBackup = window.Raphael
      @raphaelStub = window.Raphael = sinon.spy()

      @trackView = TrackView.create()
      @trackView.drawTrack = sinon.spy()

      @container = jQuery '<div>'
      Ember.run => @trackView.appendTo @container

    afterEach ->
      window.Raphael = @raphaelBackup

    it 'should create raphael paper', ->
      (expect @raphaelStub).toHaveBeenCalledWith @trackView.$()[0], 1024, 768

    it 'should draw the track', ->
      (expect @trackView.drawTrack).toHaveBeenCalled()
