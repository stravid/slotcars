
#= require helpers/math/raphael_path
#= require helpers/math/path
#= require vendor/raphael

describe 'raphael path', ->

  RaphaelPath = helpers.math.RaphaelPath

  it 'should be an ember object', ->
    (expect RaphaelPath).toExtend Ember.Object

  beforeEach ->
    @pathMock = mockEmberClass helpers.math.Path,
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
      raphaelPath = RaphaelPath.create()

      raphaelPath.addPoint testPoint

      (expect @pathMock.push).toHaveBeenCalledWith testPoint, true


  describe 'updating of path string', ->

    beforeEach ->
      @raphaelPath = RaphaelPath.create()

      @firstPoint = { x: 1, y: 0 }
      @secondPoint = { x: 2, y: 1 }
      @thirdPoint = { x: 3, y: 2 }
      @fourthPoint = { x: 4, y: 5 }

    it 'should use an empty path by default and provide default raphael path', ->
      (expect @raphaelPath.get 'path').not.toBe undefined
      (expect @raphaelPath.get 'path').toBe RaphaelPath.EMPTY_PATH_STRING

    it 'should keep default empty path when points count < 3', ->
      @pathMock.length = 1
      @raphaelPath.addPoint @firstPoint

      (expect @raphaelPath.get 'path').toEqual RaphaelPath.EMPTY_PATH_STRING

      @pathMock.length = 2
      @raphaelPath.addPoint @secondPoint

      (expect @raphaelPath.get 'path').toEqual RaphaelPath.EMPTY_PATH_STRING

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
      raphaelPath = RaphaelPath.create()
      expectedLength = 5.3023

      @RaphaelMock.getTotalLength = sinon.stub().returns expectedLength
      totalLength = raphaelPath.get 'totalLength'

      (expect totalLength).toBe expectedLength



  describe 'getting point on length of track', ->

    it 'should as Raphael for point at specific length on path', ->
      raphaelPath = RaphaelPath.create()
      expectedPoint = { x: 3, y: 31 }

      @RaphaelMock.getPointAtLength = sinon.stub().returns expectedPoint

      resultingPoint = raphaelPath.getPointAtLength 1

      (expect resultingPoint).toBe expectedPoint


  describe 'clearing the path', ->

    beforeEach ->
      @pathMock.clear = sinon.spy()
      @raphaelPath = RaphaelPath.create()

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

      (expect @raphaelPath.get 'path').toBe RaphaelPath.EMPTY_PATH_STRING



  describe 'rasterizing the path for performance lookups', ->

    beforeEach ->
      @points = [
        { x: 0, y: 0 }
        { x: 1, y: 0 }
        { x: 2, y: 0 }
      ]

      @pathMock.asPointArray.returns @points

      @RaphaelMock.getTotalLength = sinon.stub().returns 10
      @RaphaelMock.getPointAtLength = sinon.stub()

      @RaphaelMock.getPointAtLength.withArgs(@pathMock, 0).returns @points[0]
      @RaphaelMock.getPointAtLength.withArgs(@pathMock, 5).returns @points[1]
      @RaphaelMock.getPointAtLength.withArgs(@pathMock, 10).returns @points[2]

      @rasterizationSize = 5 # rasterize three points

      @raphaelPath = RaphaelPath.create()
      @expectedPath = 'bla'
      @raphaelPath.set 'path', @expectedPath

    it 'should ask for points from Raphael in given steps', ->
      @raphaelPath.rasterize @rasterizationSize

      (expect @RaphaelMock.getPointAtLength).toHaveBeenCalledWith @expectedPath, 0
      (expect @RaphaelMock.getPointAtLength).toHaveBeenCalledWith @expectedPath, 5
      (expect @RaphaelMock.getPointAtLength).toHaveBeenCalledWith @expectedPath, 10