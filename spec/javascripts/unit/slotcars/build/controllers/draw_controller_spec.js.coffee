
#= require slotcars/build/controllers/draw_controller

describe 'slotcars.build.controllers.DrawController', ->

  DrawController = slotcars.build.controllers.DrawController

  it 'should be an Ember.Object', ->
    (expect DrawController).toExtend Ember.Object

  beforeEach ->
    @trackMock = Ember.Object.create addPathPoint: sinon.spy()
    @drawController = DrawController.create
      track: @trackMock


  describe 'important default values', ->

    it 'should not be finished with drawing when created', ->
      (expect @drawController.finishedDrawing).toBe false


  describe 'add path points to track model on mouse move', ->

    it 'should accept a point and tell the track model to add it', ->
      testPoint = x: 0, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).toHaveBeenCalledWith testPoint

    it 'should not add further points when user finished drawing', ->
      @drawController.finishedDrawing = true

      testPoint = x: 0, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).not.toHaveBeenCalledWith testPoint


  describe 'clearing the track path', ->

    it 'should tell the track model to clear path', ->
      @trackMock.clearPath = sinon.spy()

      @drawController.onClearTrack()

      (expect @trackMock.clearPath).toHaveBeenCalled()

    it 'should enable drawing', ->
      @trackMock.clearPath = sinon.spy()
      @drawController.finishedDrawing = true

      @drawController.onClearTrack()

      (expect @drawController.finishedDrawing).toBe false


  describe 'cleaning the track when user finished drawing', ->

    beforeEach ->
      @trackMock.cleanPath = sinon.spy()

    it 'should clean the track on mouse up event', ->
      @drawController.onTouchMouseUp()

      (expect @trackMock.cleanPath).toHaveBeenCalled()

    it 'should set finished drawing to true', ->
      @drawController.onTouchMouseUp()

      (expect @drawController.finishedDrawing).toBe true


  describe 'playing created track', ->

    beforeEach ->
      @trackMock.rasterize = sinon.spy()
      @trackMock.playRoute = 'test/route'

      @routeManagerBackup = slotcars.routeManager
      slotcars.routeManager = sinon.stub()
      slotcars.routeManager.set = sinon.spy()

    afterEach ->
      slotcars.routeManager = @routeManagerBackup

    it 'should tell the track to rasterize itself', ->
      @drawController.onPlayCreatedTrack()

      (expect @trackMock.rasterize).toHaveBeenCalled()

    it 'should provide a callback that changes the current location to play', ->
      @drawController.onPlayCreatedTrack()

      rasterizationFinishCallback = @trackMock.rasterize.args[0][0]
      rasterizationFinishCallback() # normally called by track

      (expect slotcars.routeManager.set).toHaveBeenCalledWith 'location', @trackMock.playRoute