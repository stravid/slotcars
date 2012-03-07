
#= require slotcars/build/views/draw_view
#= require slotcars/shared/views/track_view
#= require slotcars/build/controllers/draw_controller

describe 'slotcars.build.views.DrawView', ->

  TrackView = slotcars.shared.views.TrackView
  DrawView = slotcars.build.views.DrawView
  DrawController = slotcars.build.controllers.DrawController

  it 'should extend TrackView', ->
    (expect DrawView).toExtend TrackView

  describe 'important default values', ->

    it 'should not be in drawing mode by default', ->
      drawView = DrawView.create()
      (expect drawView.isDrawing).toBe false


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

    it 'should not throw exceptions when created without controller', ->
      DrawView.create()

      (expect -> Ember.run.end()).not.toThrow()


  describe 'rendering of track', ->

    beforeEach ->
      @originalTestPath = 'M0,0L3,4Z'
      @drawView = DrawView.create()

      @drawView.appendTo '<div>'
      Ember.run.end()

    it 'should tell raphael to build a closed track while not in drawing mode', ->

      @drawView.isDrawing = false
      @drawView.drawTrack @originalTestPath

      (expect @paperStub.path).toHaveBeenCalledWith @originalTestPath

    it 'should tell raphael to build an open track while in drawing mode', ->

      @drawView.isDrawing = true
      modifiedPathWithoutZ = 'M0,0L3,4'

      @drawView.drawTrack @originalTestPath

      (expect @paperStub.path).toHaveBeenCalledWith modifiedPathWithoutZ


  describe 'event handling in draw view', ->

    beforeEach ->
      @drawControllerMock = mockEmberClass DrawController
      @drawView = DrawView.create drawController: @drawControllerMock

      # append it into DOM to test real jQuery events
      @drawView.appendTo '<div>'

      Ember.run.end()

    afterEach ->
      @drawControllerMock.restore()


    describe 'mouse down events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseDown = sinon.spy()

      it 'should setup mouse down listeners and tell controller about events', ->
        (jQuery @drawView.$()).trigger 'touchMouseDown'

        (expect @drawControllerMock.onTouchMouseDown).toHaveBeenCalled()

      it 'should activate drawing mode', ->
        (jQuery @drawView.$()).trigger 'touchMouseDown'

        (expect @drawView.isDrawing).toBe true

      it 'should unbind the mouse down event when removed', ->
        @drawView.willDestroyElement()
        (jQuery @drawView.$()).trigger 'touchMouseDown'

        (expect @drawControllerMock.onTouchMouseDown).not.toHaveBeenCalled()


    describe 'mouse move events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseMove = sinon.spy()

      it 'should setup touch mouse move listener on its view element that notifies draw controller', ->
        # manually create touch mouse move event
        testPosition = x: 3, y: 4
        touchMouseMoveEvent = jQuery.Event 'touchMouseMove', pageX: testPosition.x, pageY: testPosition.y

        (jQuery @drawView.$()).trigger touchMouseMoveEvent

        (expect @drawControllerMock.onTouchMouseMove).toHaveBeenCalledWithAnObjectLike testPosition


      it 'should unbind the mouse move events when view will be removed', ->
        @drawView.willDestroyElement()
        (jQuery @drawView.$()).trigger 'touchMouseMove', {}

        (expect @drawControllerMock.onTouchMouseMove).not.toHaveBeenCalled()


    describe 'mouse up events', ->

      beforeEach ->
        @drawControllerMock.onTouchMouseUp = sinon.spy()

      it 'should setup mouse up listeners and tell controller about events', ->
        (jQuery @drawView.$()).trigger 'touchMouseUp'

        (expect @drawControllerMock.onTouchMouseUp).toHaveBeenCalled()

      it 'should de-activate drawing mode', ->
        @drawView.isDrawing = true

        (jQuery @drawView.$()).trigger 'touchMouseUp'

        (expect @drawView.isDrawing).toBe false

      it 'should unbind the mouse down event when removed', ->
        @drawView.willDestroyElement()
        (jQuery @drawView.$()).trigger 'touchMouseUp'

        (expect @drawControllerMock.onTouchMouseUp).not.toHaveBeenCalled()
