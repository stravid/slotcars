
#= require slotcars/shared/views/track_view

describe 'track view', ->

  TrackView = slotcars.shared.views.TrackView

  it 'should be a subclass of ember view', ->
    (expect Ember.View.detect TrackView).toBe true

  it 'should have an element id', ->
    trackView = TrackView.create()
    (expect trackView.get 'elementId').toBe 'track-view'

  describe 'creation of raphael paper', ->

    beforeEach ->
      @raphaelBackup = window.Raphael
      @raphaelStub = window.Raphael = sinon.spy()

    afterEach ->
      window.Raphael = @raphaelBackup

    it 'should create raphael paper when inserted into DOM', ->
      @container = jQuery '<div>'

      @trackView = TrackView.create()
      Ember.run => @trackView.appendTo @container

      (expect @raphaelStub).toHaveBeenCalledWith @trackView.$()[0], 1024, 768