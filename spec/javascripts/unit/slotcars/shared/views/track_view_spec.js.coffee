
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

    it 'should save the path if not in DOM and draw it when inserted', ->
      trackView = TrackView.create()
      path = 'M0,0Z'
  
      trackView.drawTrack path
      trackView.drawTrack = sinon.spy()

      trackView.didInsertElement()

      (expect trackView.drawTrack).toHaveBeenCalledWith path

    it 'should clear the paper before drawing', ->
      @trackView.drawTrack('M0,0Z')

      (expect @paperClearSpy).toHaveBeenCalled()

  describe 'bind/unbind car controls', ->

    beforeEach ->
      @gameControllerMock.onTouchMouseDown = sinon.spy()
      @gameControllerMock.onTouchMouseUp = sinon.spy()

    describe 'when controls are enabled', ->
  
      it 'should call onTouchMouseDown on game controller when controls are enabled', ->
        @gameControllerMock.get = sinon.stub().withArgs('carControlsEnabled').returns true
        @trackView.onCarControlsChange()

        (jQuery @trackView.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).toHaveBeenCalled()

    describe 'when controls are disabled', ->

      it 'should call onTouchMouseDown on game controller when controls are enabled', ->
        @gameControllerMock.get = sinon.stub().withArgs('carControlsEnabled').returns false
        @trackView.onCarControlsChange()

        (jQuery @trackView.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).not.toHaveBeenCalled()
