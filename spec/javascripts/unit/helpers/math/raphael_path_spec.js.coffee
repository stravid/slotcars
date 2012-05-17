describe 'raphael path', ->

  it 'should be an ember object', ->
    (expect Shared.RaphaelPath).toExtend Ember.Object

  beforeEach ->
    @pathMock = mockEmberClass Shared.Path,
      push: sinon.spy()
      asPointArray: sinon.stub().returns []
      length: 0

    @RaphaelBackup = window.Raphael
    @RaphaelMock = window.Raphael = {}

  afterEach ->
    @pathMock.restore()
    window.Raphael = @RaphaelBackup


  describe 'adding path points', ->

    it 'should push point into its path and tell it to calculate angle', ->
      testPoint = { x: 1, y: 0 }
      raphaelPath = Shared.RaphaelPath.create()

      raphaelPath.addPoint testPoint

      (expect @pathMock.push).toHaveBeenCalledWith testPoint, true


  describe 'getting path points as array', ->

    it 'should fetch path points from its path', ->
      raphaelPath = Shared.RaphaelPath.create()
      raphaelPath.getPathPointArray()

      (expect @pathMock.asPointArray).toHaveBeenCalled()


  describe 'updating of path string', ->

    beforeEach ->
      @raphaelPath = Shared.RaphaelPath.create()

      @firstPoint = { x: 1, y: 0 }
      @secondPoint = { x: 2, y: 1 }
      @thirdPoint = { x: 3, y: 2 }

    it 'should use an empty path by default and provide default raphael path', ->
      (expect @raphaelPath.get 'path').not.toBe undefined
      (expect @raphaelPath.get 'path').toBe Shared.RaphaelPath.EMPTY_PATH_STRING

    it 'should keep default empty path when points count < 3', ->
      @pathMock.length = 1
      @raphaelPath.addPoint @firstPoint

      (expect @raphaelPath.get 'path').toEqual Shared.RaphaelPath.EMPTY_PATH_STRING

      @pathMock.length = 2
      @raphaelPath.addPoint @secondPoint

      (expect @raphaelPath.get 'path').toEqual Shared.RaphaelPath.EMPTY_PATH_STRING

    it 'should update catmull rom path correctly when more points than 2 were added', ->
      # raphael path loops over point array internally
      @pathMock.asPointArray.returns [ @firstPoint, @secondPoint, @thirdPoint ]
      @pathMock.length = 3

      @raphaelPath.addPoint @firstPoint
      @raphaelPath.addPoint @secondPoint
      @raphaelPath.addPoint @thirdPoint

      (expect @raphaelPath.get 'path').toEqual 'M1,0R2,1,3,2z'


  describe 'total length of path', ->

    it 'should return the paths current total lenght', ->
      raphaelPath = Shared.RaphaelPath.create()
      expectedLength = 5.3023

      @RaphaelMock.getTotalLength = sinon.stub().returns expectedLength
      totalLength = raphaelPath.get 'totalLength'

      (expect totalLength).toBe expectedLength


  describe 'getting point on length of track', ->

    it 'should ask Raphael for point at specific length on path', ->
      raphaelPath = Shared.RaphaelPath.create()
      expectedPoint = { x: 3, y: 31 }

      @RaphaelMock.getPointAtLength = sinon.stub().returns expectedPoint

      resultingPoint = raphaelPath.getPointAtLength 1

      (expect resultingPoint).toBe expectedPoint


  describe 'clearing the path', ->

    beforeEach ->
      @pathMock.clear = sinon.spy()
      @raphaelPath = Shared.RaphaelPath.create()

    it 'should tell the path to clear', ->
      @raphaelPath.clear()

      (expect @pathMock.clear).toHaveBeenCalled()

    it 'should update the path property and trigger bindings', ->
      @raphaelPath.set 'path', 'somePathValue'
      pathObserver = sinon.spy()

      @raphaelPath.addObserver 'path', pathObserver
      @raphaelPath.clear()

      (expect pathObserver).toHaveBeenCalled()

    it 'should reset the path to default value', ->
      @raphaelPath.clear()

      (expect @raphaelPath.get 'path').toBe Shared.RaphaelPath.EMPTY_PATH_STRING


  describe 'cleaning the path', ->

    beforeEach ->
      @raphaelPath = Shared.RaphaelPath.create()
      @pathMock.clean = sinon.spy()

    it 'should tell the path to clean with given parameters', ->
      parameters = {}

      @raphaelPath.clean parameters

      (expect @pathMock.clean).toHaveBeenCalledWith parameters

    it 'should update the path property after cleaning', ->
      @pathMock.length = 3
      @pathMock.asPointArray.returns [
        { x: 0,  y: 0  }
        { x: 10, y: 5  }
        { x: 5,  y: 10 }
      ]

      pathBeforeClean = @raphaelPath.get 'path'

      @raphaelPath.clean {}

      pathAfterClean = @raphaelPath.get 'path'

      (expect pathAfterClean).not.toEqual pathBeforeClean


  describe 'rasterizing the path for performance lookups', ->

    beforeEach ->
      # rasterization checks for previous to last point's angle
      @pathMock.tail = previous: angle: 1

      @raphaelPath = Shared.RaphaelPath.create()
      @path = @raphaelPath.get 'path'

      @RaphaelMock.getPointAtLength = sinon.stub()

      # testing params
      @parameters =
        minimumLengthPerPoint: 1
        lengthLimitForAngleFactor: 20
        minimumAngle: 0.3
        lengthPerRasterizingPhase: 10

      # there must be a minimum of two points rasterized
      @RaphaelMock.getTotalLength = sinon.stub().returns 2

      @EmberNextBackup = Ember.run.next
      Ember.run.next = sinon.stub()

    afterEach ->
      Ember.run.next = @EmberNextBackup


    it 'should push point at current length into rasterization path', ->
      testPoint = {}
      @RaphaelMock.getTotalLength = sinon.stub().returns 2
      expectedLength = 1
      @parameters.currentLength = expectedLength

      @RaphaelMock.getPointAtLength.withArgs(@path, expectedLength).returns testPoint

      @raphaelPath.rasterize @parameters

      (expect @pathMock.push).toHaveBeenCalledWithExactly testPoint, true

    it 'should consider angle of last point for length to next point', ->
      previousPointAngle = 2
      @pathMock.tail = previous: angle: previousPointAngle

      expectedPoint = {}
      expectedLength = @parameters.minimumLengthPerPoint + 1 / Math.pow previousPointAngle, 2
      @RaphaelMock.getPointAtLength.withArgs(@path, expectedLength).returns expectedPoint

      @raphaelPath.rasterize @parameters

      (expect @pathMock.push).toHaveBeenCalledWithExactly expectedPoint, true

    it 'should take length limit for angle factor if the factor is too big', ->
      # very low angles would result in (too) high length distances (1 / (0,1 * 0,1) = 100)
      @pathMock.tail = previous: angle: 0.1
      # simulate path length of 101
      @RaphaelMock.getTotalLength = sinon.stub().returns 101
      @parameters.lengthPerRasterizingPhase = 101

      expectedPoint = {}
      expectedLength = @parameters.lengthLimitForAngleFactor
      @RaphaelMock.getPointAtLength.withArgs(@path, expectedLength).returns expectedPoint

      @raphaelPath.rasterize @parameters

      (expect @pathMock.push).toHaveBeenCalledWithExactly expectedPoint, true

    it 'should remove points with an angle lower than minimum angle', ->
      # add a point at the head that should be removed
      @pathMock.head = angle: @parameters.minimumAngle - 0.001
      @pathMock.remove = sinon.stub()

      @raphaelPath.rasterize @parameters

      (expect @pathMock.remove).toHaveBeenCalledWith @pathMock.head


    it 'should call the progress handler with rasterized length', ->
      expectedCurrentEndLength = 2
      progressCallback = sinon.spy()

      @parameters.currentLength = 1
      @parameters.onProgress = progressCallback

      @raphaelPath.rasterize @parameters

      (expect progressCallback).toHaveBeenCalledWith expectedCurrentEndLength


    it 'should tell ember to run rasterize on next tick and avoid infinite loops', ->
      # let it rasterize twice (call ember once)
      @RaphaelMock.getTotalLength = sinon.stub().returns 2 * @parameters.lengthPerRasterizingPhase

      @raphaelPath.rasterize @parameters

      # extract anonymous callback provided to Ember.run.next
      rasterizeCallbackProvidedToEmber = Ember.run.next.args[0][0]

      # let jasmine spy on and call original method to test recursion
      rasterizeStub = (spyOn @raphaelPath, 'rasterize').andCallThrough()

      # simulate Ember that calls on next tick
      rasterizeCallbackProvidedToEmber()

      (expect Ember.run.next).toHaveBeenCalledOnce()


    it 'should rasterize until the end is reached and then tell finish callback', ->
      finishSpy = sinon.spy()
      @parameters.onFinished = finishSpy

      # let it rasterize three times (call ember twice)
      @RaphaelMock.getTotalLength = sinon.stub().returns 3 * @parameters.lengthPerRasterizingPhase

      # simulate Ember.run.next by always calling the callback immediately
      Ember.run.next.yields()

      @raphaelPath.rasterize @parameters

      (expect Ember.run.next).toHaveBeenCalledTwice()
      (expect finishSpy).toHaveBeenCalledOnce()


  describe 'setting the raphael path', ->

    it 'should set the raphael path', ->
      raphaelPath = Shared.RaphaelPath.create()
      path = "M0,0L1,0z"

      raphaelPath.setRaphaelPath path

      (expect raphaelPath.get 'path').toEqual path


  describe 'setting the rasterized path', ->

    it 'should set the rasterized path', ->
      @pathMock.restore()

      raphaelPath = Shared.RaphaelPath.create()
      points = [
        { x: '1', y: '2', angle: '3' }
      ]

      raphaelPath.setRasterizedPath points

      (expect (raphaelPath.get '_rasterizedPath').head.x).toEqual 1
      (expect (raphaelPath.get '_rasterizedPath').head.y).toEqual 2
      (expect (raphaelPath.get '_rasterizedPath').head.angle).toEqual 3


  describe 'setting a new linked path', ->

    beforeEach ->
      @points = [ { x: 1, y: 0 }, { x: 0, y: 1 } ]
      @raphaelPath = Shared.RaphaelPath.create()

      # pretends that path has already been rasterized
      @raphaelPath._rasterizedPath = @pathMock

    it 'should destroy the old path and the rasterized path', ->
      sinon.spy @pathMock, 'destroy'

      @raphaelPath.setLinkedPath @points

      (expect @pathMock.destroy).toHaveBeenCalledTwice()

    it 'should create a new path and set it as property', ->
      sinon.spy @raphaelPath, 'set'

      @raphaelPath.setLinkedPath @points

      (expect @pathMock.create).toHaveBeenCalledWith points: @points
      (expect @raphaelPath.set).toHaveBeenCalledWith '_path', @pathMock

    it 'should create a new rasterized path and set it as property', ->
      sinon.spy @raphaelPath, 'set'

      @raphaelPath.setLinkedPath @points

      (expect @pathMock.create).toHaveBeenCalled()
      (expect @raphaelPath.set).toHaveBeenCalledWith '_rasterizedPath', @pathMock
