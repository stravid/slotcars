
#= require slotcars/build/views/draw_view
#= require slotcars/shared/views/track_view
#= require slotcars/build/controllers/draw_controller

describe 'slotcars.build.views.DrawView', ->

  TrackView = slotcars.shared.views.TrackView
  DrawView = slotcars.build.views.DrawView
  DrawController = slotcars.build.controllers.DrawController

  DRAW_VIEW_PAPER_WRAPPER_ID = '#draw-view-paper'

  it 'should extend TrackView', ->
    (expect DrawView).toExtend TrackView


  beforeEach ->
    @raphaelBackup = window.Raphael

    raphaelElementStub = attr: sinon.spy()

    @paperStub =
      path: sinon.stub().returns raphaelElementStub
      rect: sinon.stub().returns raphaelElementStub
      clear: sinon.spy()

    @raphaelStub = window.Raphael = sinon.stub().returns @paperStub


  afterEach ->
    window.Raphael = @raphaelBackup


  describe 'raphaelPath bindings on track', ->

    it 'should not throw exceptions when track is not yet available', ->
      DrawView.create()

      (expect -> Ember.run.end()).not.toThrow()


  describe 'rendering of track', ->

    beforeEach ->
      @originalTestPath = 'M0,0L3,4Z'
      @drawController = DrawController.create()

      @drawView = DrawView.create drawController: @drawController

      @drawView.appendTo '<div>'
      Ember.run.end()

    it 'should create raphael paper view is appended to DOM', ->
      (expect @raphaelStub).toHaveBeenCalledWith @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)[0], 1024, 768

    it 'should tell raphael to build a closed track while not in drawing mode', ->
      @drawController.set 'finishedDrawing', true
      @drawView.drawTrack @originalTestPath

      (expect @paperStub.path).toHaveBeenCalledWith @originalTestPath

    it 'should tell raphael to build an open track while in drawing mode', ->

      @drawController.set 'finishedDrawing', false
      modifiedPathWithoutZ = 'M0,0L3,4'

      @drawView.drawTrack @originalTestPath

      (expect @paperStub.path).toHaveBeenCalledWith modifiedPathWithoutZ


  describe 'event handling in draw view when appended to DOM', ->

    beforeEach ->
      @drawControllerMock = mockEmberClass DrawController
      @drawView = DrawView.create drawController: @drawControllerMock

      # append it into DOM to test real jQuery events
      @drawView.appendTo '<div>'

      Ember.run.end()

    afterEach -> @drawControllerMock.restore()


    describe 'mouse move events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseMove = sinon.spy()


      it 'should not bind mouse move before mouse down happened', ->
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseMove'

        (expect @drawControllerMock.onTouchMouseMove).not.toHaveBeenCalled()


      it 'should bind mouse move on mouse down', ->
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseDown'
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseMove'

        (expect @drawControllerMock.onTouchMouseMove).toHaveBeenCalled()

      it 'should notifiy draw controller of move events', ->
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseDown'

        # manually create touch mouse move event
        testPosition = x: 3, y: 4
        touchMouseMoveEvent = jQuery.Event 'touchMouseMove', pageX: testPosition.x, pageY: testPosition.y

        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger touchMouseMoveEvent

        (expect @drawControllerMock.onTouchMouseMove).toHaveBeenCalledWithAnObjectLike testPosition


    describe 'mouse up events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseUp = sinon.spy()

      it 'should setup mouse up listeners and tell controller about events', ->
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseUp'

        (expect @drawControllerMock.onTouchMouseUp).toHaveBeenCalled()

      it 'should unbind the mouse up event when removed', ->
        @drawView.willDestroyElement()
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseUp'

        (expect @drawControllerMock.onTouchMouseUp).not.toHaveBeenCalled()

      it 'should unbind the mouse move event', ->
        @drawControllerMock.onTouchMouseMove = sinon.spy()

        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseDown'
        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseUp'

        (jQuery @drawView.$(DRAW_VIEW_PAPER_WRAPPER_ID)).trigger 'touchMouseMove'

        (expect @drawControllerMock.onTouchMouseMove).not.toHaveBeenCalled()


    describe 'clearing the track', ->

      it 'should tell the controller when user clicked the clear button', ->
        @drawControllerMock.onClearTrack = sinon.spy()

        @drawView.onClearButtonClicked()

        (expect @drawControllerMock.onClearTrack).toHaveBeenCalled()


    describe 'playing created track', ->

      it 'should tell the controller when the user wants to play the created track', ->
        @drawControllerMock.onPlayCreatedTrack = sinon.spy()

        @drawView.onPlayCreatedTrackButtonClicked()

        (expect @drawControllerMock.onPlayCreatedTrack).toHaveBeenCalled()
