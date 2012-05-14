
describe 'Shared.Rasterizable', ->

  beforeEach ->
    @raphaelPathMock = mockEmberClass Shared.RaphaelPath,
      setRaphaelPath: sinon.spy(),
      setRasterizedPath: sinon.spy()

  afterEach ->
    @raphaelPathMock.restore()

  describe 'rasterizing the track', ->

    beforeEach ->
      @track = Shared.Track.createRecord()
      @raphaelPathMock.rasterize = sinon.spy()

      @fakeRasterizedPathValue = 'fakePathValue'
      @RaphaelBackup = window.Raphael
      @RaphaelMock = window.Raphael =
        getSubpath: sinon.stub().returns @fakeRasterizedPathValue

      @emberRunLaterStub = sinon.stub(Ember.run, 'later').yields()

    afterEach ->
      window.Raphael = @RaphaelBackup
      @emberRunLaterStub.restore()


    it 'should not be rasterizing by default', ->
      (expect @track.get 'isRasterizing').toBe false

    it 'should tell when it starts rasterizing', ->
      @track.rasterize()

      (expect @track.get 'isRasterizing').toBe true

    it 'should reset the rasterized path', ->
      @track.rasterize()

      (expect @track.get 'rasterizedPath').toBe null

    it 'should defer rasterization with ember', ->
      @track.rasterize()

      (expect @emberRunLaterStub).toHaveBeenCalledOnce()

    it 'should tell the raphael path to rasterize', ->
      @track.rasterize()

      (expect @raphaelPathMock.rasterize).toHaveBeenCalled()

    it 'should configure step size for rasterization', ->
      @track.rasterize()

      providedStepSize = @raphaelPathMock.rasterize.args[0][0].stepSize

      (expect providedStepSize).toBeAPositiveNumber()

    it 'should provide rasterization progress callback that updates rasterized path', ->
      # needed to check for correct raphael path
      @raphaelPathMock.set 'path', {}

      @track.rasterize()
      testLength = 10

      # in reality called by raphael path
      @raphaelPathMock.rasterize.args[0][0].onProgress testLength

      trackPath = @track.get 'raphaelPath'

      (expect @RaphaelMock.getSubpath).toHaveBeenCalledWith trackPath, 0, testLength
      (expect @track.get 'rasterizedPath').toEqual @fakeRasterizedPathValue

    it 'should provide finish callback that resets rasterizing state', ->
      @track.rasterize()

      # in reality called by raphael path
      @raphaelPathMock.rasterize.args[0][0].onFinished()

      (expect @track.get 'isRasterizing').toBe false

    it 'should call finish callback that rasterization finished', ->
      finishCallback = sinon.spy()
      @track.rasterize finishCallback

      # in reality called by raphael path
      @raphaelPathMock.rasterize.args[0][0].onFinished()

      (expect finishCallback).toHaveBeenCalled()