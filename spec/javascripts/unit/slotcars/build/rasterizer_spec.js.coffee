describe 'rasterizer', ->

  Rasterizer = Slotcars.build.Rasterizer
  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager
  BuildScreenView = slotcars.build.views.BuildScreenView
  RasterizationView = Slotcars.build.views.RasterizationView

  beforeEach ->
    @trackMock = Ember.Object.create
      clearPath: sinon.spy()
      rasterize: sinon.spy()

    @buildScreenStateManagerMock = mockEmberClass BuildScreenStateManager, send: sinon.spy()
    @buildScreenViewMock = mockEmberClass BuildScreenView, set: sinon.spy()
    @RasterizationViewMock = mockEmberClass RasterizationView

    @rasterizer = Rasterizer.create
      stateManager: @buildScreenStateManagerMock
      buildScreenView: @buildScreenViewMock
      track: @trackMock

  afterEach ->
    @buildScreenStateManagerMock.restore()
    @buildScreenViewMock.restore()
    @RasterizationViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect Rasterizer).toExtend Ember.Object

  it 'should create a rastrization view and provide the track', ->
    (expect @RasterizationViewMock.create).toHaveBeenCalledWithAnObjectLike track: @trackMock

  it 'should append rasterization view to build screen view view', ->
    (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @RasterizationViewMock

  describe 'start rasterization', ->

    it 'should activate rasterization mode', ->
      @rasterizer.start()

      (expect @rasterizer.get 'isRasterizing').toBe true

    it 'should tell the track to rasterize itself', ->
      @rasterizer.start()

      (expect @trackMock.rasterize).toHaveBeenCalled()

    it 'should provide a callback to inform state manager after rasterization finished', ->
      @rasterizer.start()

      rasterizationFinishCallback = @trackMock.rasterize.args[0][0]
      rasterizationFinishCallback() # normally called by track

      (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'finishedRasterization'

    it 'should not tell the track to rasterize again during the process', ->
      @rasterizer.start()
      @rasterizer.start()

      (expect @trackMock.rasterize).toHaveBeenCalledOnce()

    it 'should leave rasterization mode when finish callback was called', ->
      @rasterizer.start()

      # simulate that rasterization finished
      rasterizationFinishCallback = @trackMock.rasterize.args[0][0]
      rasterizationFinishCallback()

      (expect @rasterizer.get 'isRasterizing').toBe false

  describe 'destroying', ->

    it 'should unset the content view on build screen view', ->
      @rasterizer.destroy()

      (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', null

    it 'should destroy the rasterization view', ->
      @RasterizationViewMock.destroy = sinon.spy()
      @rasterizer.destroy()

      (expect @RasterizationViewMock.destroy).toHaveBeenCalled()
