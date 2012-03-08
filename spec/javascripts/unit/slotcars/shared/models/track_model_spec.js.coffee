
#= require embient/ember-data
#= require slotcars/shared/models/track_model
#= require helpers/math/path

describe 'slotcars.shared.models.TrackModel', ->

  TrackModel = slotcars.shared.models.TrackModel
  EMPTY_RAPHAEL_PATH = 'M0,0z'

  it 'should be a subclass of an ember-data Model', ->
    (expect TrackModel).toExtend DS.Model

  describe 'important default values', ->

  it 'should be an valid empty path with a single move to command by default', ->
    @track = TrackModel.createRecord()

    (expect @track.get 'raphaelPath').toEqual EMPTY_RAPHAEL_PATH


  beforeEach ->
    @pathMock = mockEmberClass helpers.math.Path,
      push: sinon.spy()
      asPointArray: sinon.stub().returns [ x: 1, y: 0 ]

  afterEach ->
    @pathMock.restore()


  describe 'adding path points', ->

    beforeEach ->
      @track = TrackModel.createRecord()

      @firstPoint = { x: 1, y: 0 }
      @secondPoint = { x: 2, y: 1 }
      @thirdPoint = { x: 3, y: 2 }
      @fourthPoint = { x: 4, y: 5 }

    it 'should push point into its path', ->
      @track.addPathPoint @firstPoint

      (expect @pathMock.push).toHaveBeenCalledWith @firstPoint, true

    it 'should keep default empty raphael path when points count < 3', ->
      @pathMock.length = 1
      @track.addPathPoint @firstPoint

      (expect @track.get 'raphaelPath').toEqual EMPTY_RAPHAEL_PATH

      @pathMock.length = 2
      @track.addPathPoint @secondPoint

      (expect @track.get 'raphaelPath').toEqual EMPTY_RAPHAEL_PATH

    it 'should update raphael path correctly when more points than 2 were added', ->
      @pathMock.asPointArray.returns [ @firstPoint, @secondPoint, @thirdPoint ]

      @track.addPathPoint @firstPoint
      @track.addPathPoint @secondPoint
      @track.addPathPoint @thirdPoint

      (expect @track.get 'raphaelPath').toEqual 'M1,0R2,1,3,2z'


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

      (expect @track.raphaelPath).toBe EMPTY_RAPHAEL_PATH


  describe 'cleaning the path', ->

    beforeEach ->
      @pathMock.clean = sinon.spy()
      @track = TrackModel.createRecord()

    it 'should tell the path to clean itself', ->
      @track.cleanPath()

      (expect @pathMock.clean).toHaveBeenCalledWithAnObjectLike minAngle: 20, minLength: 30, maxLength: 200

    it 'should update the raphael path', ->
      raphaelPathObserver = sinon.spy()

      @track.addObserver 'raphaelPath', raphaelPathObserver
      @track.cleanPath()

      (expect raphaelPathObserver).toHaveBeenCalled()