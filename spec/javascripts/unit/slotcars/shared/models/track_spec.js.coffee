describe 'slotcars.shared.models.Track', ->

  Track = slotcars.shared.models.Track
  RaphaelPath = helpers.math.RaphaelPath
  ModelStore = slotcars.shared.models.ModelStore

  it 'should be a subclass of an ember-data Model', ->
    (expect Track).toExtend DS.Model

  it 'should provide correct namespace on toString', ->
    (expect Track.toString()).toBe 'slotcars.shared.models.Track'

  beforeEach ->
    @raphaelPathMock = mockEmberClass RaphaelPath, setRaphaelPath: sinon.spy(), setRasterizedPath: sinon.spy()

  afterEach ->
    @raphaelPathMock.restore()


  describe 'binding raphael path', ->

    it 'should bind raphaelPath property to path of RaphaelPath instance', ->
      expectedPathValue = 'test'
      track = Track.createRecord()

      @raphaelPathMock.set 'path', expectedPathValue

      Ember.run.end()

      (expect track.get 'raphaelPath').toEqual expectedPathValue


  describe 'adding path points', ->

    it 'should tell its raphael path to add points', ->
      track = Track.createRecord()
      point = { x: 1, y: 0 }
      @raphaelPathMock.addPoint = sinon.spy()

      track.addPathPoint point

      (expect @raphaelPathMock.addPoint).toHaveBeenCalledWith point


  describe 'getting total length of path', ->

    it 'should ask its raphael path for total length', ->
      track = Track.createRecord()
      expectedLength = Math.random() * 10
      @raphaelPathMock.get = sinon.stub().withArgs('totalLength').returns expectedLength

      totalLength = track.getTotalLength()

      (expect totalLength).toBe expectedLength


  describe 'getting point on length of track', ->

    it 'should return the point at specific length on path', ->
      length = 1
      fakePointAtLength = {}
      @raphaelPathMock.getPointAtLength = sinon.stub().withArgs(length).returns fakePointAtLength

      track = Track.createRecord()
      resultPoint = track.getPointAtLength length

      (expect resultPoint).toBe fakePointAtLength


  describe 'clearing the path', ->

    beforeEach ->
      @raphaelPathMock.clear = sinon.spy()
      @track = Track.createRecord()

    it 'should tell the path to clear', ->
      @track.clearPath()

      (expect @raphaelPathMock.clear).toHaveBeenCalled()


  describe 'cleaning the path', ->

    beforeEach ->
      @raphaelPathMock.clean = sinon.spy()
      @raphaelPathMock.rasterize = sinon.spy()
      @track = Track.createRecord()

    it 'should tell the path to clean itself', ->
      @track.cleanPath()

      (expect @raphaelPathMock.clean).toHaveBeenCalled()

    it 'should not tell the raphael path to rasterize immediately', ->
      @track.cleanPath()

      (expect @raphaelPathMock.rasterize).not.toHaveBeenCalled()

  describe 'route to the track resource', ->

    it 'should return the correct route with client id', ->
      track = Track.createRecord()
      id = track.get 'clientId'

      (expect track.get 'playRoute').toEqual "play/#{id}"


  describe 'lap count for tracks', ->

    it 'should return the same static number of laps for all tracks', ->
      @track = Track.createRecord()

      (expect @track.get 'numberOfLaps').toBe 3


  describe 'asking if specific length on track is after finish line', ->

    beforeEach ->
      @fakePathLength = 1
      @raphaelPathMock.totalLength = @fakePathLength
      @track = Track.createRecord()

    it 'should return true when asked for length after finish line', ->
      lengthThatShouldBeAfter = (@track.get 'numberOfLaps') * @fakePathLength + 0.00001
      (expect @track.isLengthAfterFinishLine lengthThatShouldBeAfter).toBe true

    it 'should return false when asked length is before finish line', ->
      lengthThatShouldNotBeAfter = (@track.get 'numberOfLaps') * @fakePathLength - 0.00001
      (expect @track.isLengthAfterFinishLine lengthThatShouldNotBeAfter).toBe false


  describe 'asking for lap at length', ->

    beforeEach ->
      @fakePathLength = 1
      @raphaelPathMock.totalLength = @fakePathLength
      @track = Track.createRecord()

    it 'should return first lap for lengths smaller than the path length', ->
      lengthLessThanFirstLap = @fakePathLength - 0.0001

      (expect @track.lapForLength lengthLessThanFirstLap).toBe 1

    it 'should return second lap for length between first and second lap', ->
      lengthBetweenFirstAndSecondLap = @fakePathLength + 0.0001

      (expect @track.lapForLength lengthBetweenFirstAndSecondLap).toBe 2

    it 'should clamp the return value to maximum number of laps', ->
      lengthBiggerThanTotalLaps = @fakePathLength * (@track.get 'numberOfLaps') + 1

      (expect @track.lapForLength lengthBiggerThanTotalLaps).toBe @track.get 'numberOfLaps'


  describe 'rasterizing the track', ->

    beforeEach ->
      @track = Track.createRecord()
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

    describe '#didLoad', ->

      it 'should setup the raphael path', ->
        raphael = 'M0,0L1,0z'
        rasterized = '[{"x":"1.00","y":"1.00","angle":"1.00"}]'
        points =
          points: JSON.parse rasterized

        track = Track.createRecord()

        track.set 'raphael', raphael
        track.set 'rasterized', rasterized

        track.didLoad()

        (expect @raphaelPathMock.setRaphaelPath).toHaveBeenCalledWith raphael
        (expect @raphaelPathMock.setRasterizedPath).toHaveBeenCalledWith points

    describe '#save', ->

      beforeEach ->
        @track = Track.createRecord()
        @raphaelPathMock.get = sinon.stub()
        @raphaelPathMock.get.withArgs('_rasterizedPath').returns { asFixedLengthPointArray: -> }
        @raphaelPathMock.get.withArgs('path').returns ''

        sinon.stub ModelStore, 'commit'

      afterEach ->
        ModelStore.commit.restore()

      it 'should call commit on the model store', ->
        @track.save()

        (expect ModelStore.commit).toHaveBeenCalledOnce()

      it 'should set the raphael property', ->
        path = 'M0,0L1,1z'
        @raphaelPathMock.get.withArgs('path').returns path

        @track.save()

        (expect @track.get 'raphael').toBe path

      it 'should set the rasterized property', ->
        fixedLengthPointArray = [
          { x: '1.00', y: '1.00', angle: '1.00' }
        ]
        @raphaelPathMock.get.withArgs('_rasterizedPath').returns { asFixedLengthPointArray: -> fixedLengthPointArray }

        @track.save()

        (expect @track.get 'rasterized').toBe JSON.stringify fixedLengthPointArray
