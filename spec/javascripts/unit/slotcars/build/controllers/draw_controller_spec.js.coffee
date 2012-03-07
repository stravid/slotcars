
#= require slotcars/build/controllers/draw_controller

describe 'slotcars.build.controllers.DrawController', ->

  DrawController = slotcars.build.controllers.DrawController

  it 'should be an Ember.Object', ->
    (expect DrawController).toExtend Ember.Object

  beforeEach ->
    @trackModelMock = addPathPoint: sinon.spy()
    @drawController = DrawController.create
      track: @trackModelMock

  describe 'add path points to track model on mouse move', ->

    it 'should accept a point and tell the track model to add it', ->
      testPoint = x: 0, y: 0
      @drawController.onTouchMouseMove(testPoint)

      (expect @trackModelMock.addPathPoint).toHaveBeenCalledWith testPoint


  describe 'clearing the track path on mouse down', ->

    it 'should tell the track model to clear path', ->
      @trackModelMock.clearPath = sinon.spy()

      @drawController.onTouchMouseDown()

      (expect @trackModelMock.clearPath).toHaveBeenCalled()


  describe 'cleaning the track when user finished drawing', ->

    it 'should clean the track on mouse up event', ->
      @trackModelMock.cleanPath = sinon.spy()

      @drawController.onTouchMouseUp()

      (expect @trackModelMock.cleanPath).toHaveBeenCalled()