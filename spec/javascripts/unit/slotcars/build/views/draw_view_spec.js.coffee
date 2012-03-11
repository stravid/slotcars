
#= require slotcars/build/views/draw_view
#= require slotcars/shared/views/track_view
#= require slotcars/build/controllers/draw_controller

describe 'slotcars.build.views.DrawView', ->

  TrackView = slotcars.shared.views.TrackView
  DrawView = slotcars.build.views.DrawView
  DrawController = slotcars.build.controllers.DrawController
  TrackModel = slotcars.shared.models.TrackModel

  it 'should extend TrackView', ->
    (expect DrawView).toExtend TrackView

  describe 'drawing of track', ->

    it 'should tell the base class to redraw when raphael path of track changes', ->
      drawControllerStub = Ember.Object.create track: Ember.Object.create()
      drawView = DrawView.create drawController: drawControllerStub
      drawStub = sinon.stub drawView, 'drawTrack'

      drawControllerStub.track.set 'raphaelPath', 'changed'

      Ember.run.sync()

      (expect drawStub).toHaveBeenCalled()


  describe 'setup of touchMouse event listeners', ->

    it 'should setup touch mouse move listener on its view element that notifies draw controller', ->
      drawControllerMock = mockEmberClass DrawController, onTouchMouseMove: sinon.spy()
      drawView = DrawView.create drawController: drawControllerMock
      drawStub = sinon.stub drawView, 'drawTrack'

      # append it into DOM to test real jQuery events
      container = jQuery 'div'
      Ember.run => drawView.appendTo container

      # manually create touch mouse move event
      testPosition = x: 3, y: 4
      touchMouseMoveEvent = jQuery.Event 'touchMouseMove', pageX: testPosition.x, pageY: testPosition.y

      (jQuery drawView.$()).trigger touchMouseMoveEvent

      (expect drawControllerMock.onTouchMouseMove).toHaveBeenCalledWithAnObjectLike testPosition