
#= require slotcars/build/controllers/draw_controller

describe 'slotcars.build.controllers.DrawController', ->

  DrawController = slotcars.build.controllers.DrawController

  it 'should be an Ember.Object', ->
    (expect DrawController).toExtend Ember.Object

  describe 'add path points to track model on mouse move', ->

    beforeEach ->
      @trackModelMock = addPathPoint: sinon.spy()
      @drawController = DrawController.create
        track: @trackModelMock

    it 'should accept a point and tell the track model to add it', ->
      testPoint = x: 0, y: 0
      @drawController.onTouchMouseMove(testPoint)

      (expect @trackModelMock.addPathPoint).toHaveBeenCalledWith testPoint