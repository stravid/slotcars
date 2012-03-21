
#= require slotcars/play/views/play_track_view
#= require slotcars/play/controllers/game_controller
#= require slotcars/shared/models/track

describe 'slotcars.play.views.PlayTrackView (unit)', ->
  
  PlayTrackView = slotcars.play.views.PlayTrackView
  GameController = slotcars.play.controllers.GameController
  Track = slotcars.shared.models.Track

  beforeEach ->
    @raphaelBackup = window.Raphael
    @raphaelElementStub = sinon.stub().returns 
      attr: ->
      transform: ->
    @paperClearSpy = sinon.spy()

    @raphaelStub = window.Raphael = sinon.stub().returns
      path: @raphaelElementStub
      rect: @raphaelElementStub
      image: @raphaelElementStub
      clear: @paperClearSpy
      
    @raphaelStub.getPointAtLength = -> 
      x: 45, y: 23

    @track = Track.createRecord()
    @gameControllerMock = mockEmberClass GameController

    @playTrackView = PlayTrackView.create
      gameController: @gameControllerMock
      track: @track

    @playTrackView.appendTo '<div>'

    Ember.run.end()

  afterEach ->
    window.Raphael = @raphaelBackup
    @gameControllerMock.restore()

  describe 'bind/unbind car controls', ->

    beforeEach ->
      @gameControllerMock.onTouchMouseDown = sinon.spy()
      @gameControllerMock.onTouchMouseUp = sinon.spy()

    describe 'when controls are enabled', ->
  
      it 'should call onTouchMouseDown on game controller when controls are enabled', ->
        @gameControllerMock.get = sinon.stub().withArgs('carControlsEnabled').returns true
        @playTrackView.onCarControlsChange()

        (jQuery @playTrackView.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).toHaveBeenCalled()

    describe 'when controls are disabled', ->

      it 'should call onTouchMouseDown on game controller when controls are enabled', ->
        @gameControllerMock.get = sinon.stub().withArgs('carControlsEnabled').returns false
        @playTrackView.onCarControlsChange()

        (jQuery @playTrackView.$()).trigger 'touchMouseDown'

        (expect @gameControllerMock.onTouchMouseDown).not.toHaveBeenCalled()

