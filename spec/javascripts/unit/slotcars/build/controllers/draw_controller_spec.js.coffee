
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/build_screen_state_manager

describe 'slotcars.build.controllers.DrawController', ->

  DrawController = slotcars.build.controllers.DrawController
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  it 'should be an Ember.Object', ->
    (expect DrawController).toExtend Ember.Object

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, goToState: sinon.spy()
    @trackMock = Ember.Object.create addPathPoint: sinon.spy()

    @drawController = DrawController.create
      track: @trackMock
      stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()

  describe 'important default values', ->

    it 'should not be finished with drawing when created', ->
      (expect @drawController.finishedDrawing).toBe false

    it 'should not be in rasterizing mode by default', ->
      (expect @drawController.isRasterizing).toBe false


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
      @drawController.onClearTrack()

      (expect @trackMock.clearPath).toHaveBeenCalled()

    it 'should enable drawing', ->
      @drawController.finishedDrawing = true

      @drawController.onClearTrack()

      (expect @drawController.finishedDrawing).toBe false

    it 'should cancel rasterization if clicked while preparing track', ->
      @trackMock.cancelRasterization = sinon.spy()
      @drawController.isRasterizing = true

      @drawController.onClearTrack()

      (expect @trackMock.cancelRasterization).toHaveBeenCalled()
      (expect @drawController.get 'isRasterizing').toBe false


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

      # simulate that a track was already drawn
      @drawController.set 'finishedDrawing', true

    afterEach ->
      slotcars.routeManager = @routeManagerBackup

    it 'should activate rasterization mode', ->
      @drawController.onPlayCreatedTrack()

      (expect @drawController.get 'isRasterizing').toBe true

    it 'should tell the track to rasterize itself', ->
      @drawController.onPlayCreatedTrack()

      (expect @trackMock.rasterize).toHaveBeenCalled()

    it 'should provide a callback that changes the current location to play', ->
      @drawController.onPlayCreatedTrack()

      rasterizationFinishCallback = @trackMock.rasterize.args[0][0]
      rasterizationFinishCallback() # normally called by track

      (expect @buildScreenStateManagerMock.goToState).toHaveBeenCalledWith 'Testing'

    it 'should not tell the track to rasterize again during the process', ->
      @drawController.onPlayCreatedTrack()
      @drawController.onPlayCreatedTrack()

      (expect @trackMock.rasterize).toHaveBeenCalledOnce()

    it 'should leave rasterization mode when finish callback was called', ->
      @drawController.onPlayCreatedTrack()

      # simulate that rasterization finished
      finishCallback = @trackMock.rasterize.args[0][0]
      finishCallback()

      (expect @drawController.get 'isRasterizing').toBe false

    it 'dont start playing the track if not yet finished drawing it', ->
      @drawController.set 'finishedDrawing', false

      @drawController.onPlayCreatedTrack()

      (expect @drawController.get 'isRasterizing').toBe false
      (expect @trackMock.rasterize).not.toHaveBeenCalled()