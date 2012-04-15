
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/build_screen_state_manager

describe 'slotcars.build.controllers.DrawController', ->

  DrawController = slotcars.build.controllers.DrawController
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  it 'should be an Ember.Object', ->
    (expect DrawController).toExtend Ember.Object

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, send: sinon.spy()
    @trackMock = Ember.Object.create addPathPoint: sinon.spy()

    @drawController = DrawController.create
      track: @trackMock
      stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()

  describe 'add path points to track model on mouse move', ->

    it 'should add point to model if it has enough distance from last point', ->
      testPoint = x: 9999, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).toHaveBeenCalledWith testPoint

    it 'should not add point if it is too close to last added point', ->
      testPoint = x: 1, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).not.toHaveBeenCalled()

    it 'should not add further points when user finished drawing', ->
      @drawController.finishedDrawing = true

      testPoint = x: 0, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).not.toHaveBeenCalledWith testPoint

  describe 'clearing the track path', ->

    beforeEach ->
      @trackMock.clearPath = sinon.spy()

    it 'should tell the track model to clear path', ->
      @drawController.clearTrack()

      (expect @trackMock.clearPath).toHaveBeenCalled()

  describe 'cleaning the track when user finished drawing', ->

    beforeEach ->
      @trackMock.cleanPath = sinon.spy()

    it 'should clean the track on mouse up event', ->
      @drawController.onTouchMouseUp()

      (expect @trackMock.cleanPath).toHaveBeenCalled()

    it 'should signalize the end of drawing to the state manager', ->
      @drawController.onTouchMouseUp()

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'finishedDrawing'
