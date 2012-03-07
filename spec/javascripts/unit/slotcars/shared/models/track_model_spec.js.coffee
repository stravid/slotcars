
#= require embient/ember-data
#= require slotcars/shared/models/track_model
#= require helpers/math/path

describe 'slotcars.shared.models.TrackModel', ->

  TrackModel = slotcars.shared.models.TrackModel

  it 'should be a subclass of an ember-data Model', ->
    (expect TrackModel).toExtend DS.Model

  describe 'important default values', ->

  it 'should be an valid empty path with a single move to command by default', ->
    @track = TrackModel.createRecord()

    (expect @track.get 'raphaelPath').toEqual 'M0,0Z'


  beforeEach ->
    @pathMock = mockEmberClass helpers.math.Path,
      push: sinon.spy()
      asPointArray: sinon.stub().returns [ x: 1, y: 0 ]

  afterEach ->
    @pathMock.restore()


  describe 'adding path points', ->

    beforeEach ->
      @track = TrackModel.createRecord()

    it 'should push point into its path', ->
      testPoint = x: 0, y: 0
      @track.addPathPoint testPoint

      (expect @pathMock.push).toHaveBeenCalledWith testPoint, true

    it 'should update the raphael path when first point added', ->
      @track.addPathPoint x: 1, y: 0

      (expect @track.get 'raphaelPath').toEqual 'M1,0Z'

    it 'should update raphael path correctly when multiple points were added', ->
      @firstPoint = { x: 1, y: 0 }
      @secondPoint = { x: 2, y: 1 }
      @thirdPoint = { x: 3, y: 2 }

      @pathMock.asPointArray.returns [ @firstPoint, @secondPoint, @thirdPoint ]

      @track.addPathPoint @firstPoint
      @track.addPathPoint @secondPoint
      @track.addPathPoint @thirdPoint

      (expect @track.get 'raphaelPath').toEqual 'M1,0L2,1L3,2Z'


  describe 'getting total length of path', ->

    it 'should return the paths current total lenght', ->
      fakeTotalLength = 1
      @pathMock.getTotalLength = -> return fakeTotalLength

      @track = TrackModel.createRecord()

      (expect @track.getTotalLength()).toEqual fakeTotalLength


  describe 'getting point on length of track', ->

    it 'should return the point at specific length on path', ->
      length = 1
      fakePointAtLength = {}
      @pathMock.getPointAtLength = sinon.stub().withArgs(length).returns fakePointAtLength

      @track = TrackModel.createRecord()
      result = @track.getPointAtLength length

      (expect result).toBe fakePointAtLength


  describe 'clearing the path', ->

    beforeEach ->
      @pathMock.clear = sinon.spy()
      @track = TrackModel.createRecord()

    it 'should tell the path to clear', ->
      @track.clearPath()

      (expect @pathMock.clear).toHaveBeenCalled()

    it 'should update the raphael path', ->
      @track.raphaelPath = 'somePathValue'
      raphaelPathObserver = sinon.spy()

      @track.addObserver 'raphaelPath', raphaelPathObserver
      @track.clearPath()

      (expect raphaelPathObserver).toHaveBeenCalled()

    it 'should reset the raphael path to default value', ->
      @track.clearPath()

      (expect @track.raphaelPath).toBe 'M0,0Z'


  describe 'cleaning the path', ->

    beforeEach ->
      @pathMock.clean = sinon.spy()
      @track = TrackModel.createRecord()

    it 'should tell the path to clean itself', ->
      @track.cleanPath()

      (expect @pathMock.clean).toHaveBeenCalledWithAnObjectLike minAngle: 10, minLength: 10, maxLength: 30

    it 'should update the raphael path', ->
      raphaelPathObserver = sinon.spy()

      @track.addObserver 'raphaelPath', raphaelPathObserver
      @track.cleanPath()

      (expect raphaelPathObserver).toHaveBeenCalled()