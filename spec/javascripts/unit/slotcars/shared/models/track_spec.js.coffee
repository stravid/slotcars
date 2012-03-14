
#= require embient/ember-data
#= require slotcars/shared/models/track
#= require helpers/math/path

describe 'slotcars.shared.models.Track', ->

  Track = slotcars.shared.models.Track
  EMPTY_RAPHAEL_PATH = 'M0,0z'

  it 'should be a subclass of an ember-data Model', ->
    (expect Track).toExtend DS.Model

  describe 'important default values', ->

    it 'should be an valid empty path with a single move to command by default', ->
      @track = Track.createRecord()

      (expect @track.get 'raphaelPath').toEqual EMPTY_RAPHAEL_PATH


  beforeEach ->
    @pathMock = mockEmberClass helpers.math.Path,
      push: sinon.spy()
      asPointArray: sinon.stub().returns [ x: 1, y: 0 ]

  afterEach ->
    @pathMock.restore()


  describe 'adding path points', ->

    beforeEach ->
      @track = Track.createRecord()

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

      @track = Track.createRecord()

      (expect @track.getTotalLength()).toEqual fakeTotalLength


  describe 'getting point on length of track', ->

    it 'should return the point at specific length on path', ->
      length = 1
      fakePointAtLength = {}
      @pathMock.getPointAtLength = sinon.stub().withArgs(length).returns fakePointAtLength

      @track = Track.createRecord()
      result = @track.getPointAtLength length

      (expect result).toBe fakePointAtLength


  describe 'clearing the path', ->

    beforeEach ->
      @pathMock.clear = sinon.spy()
      @track = Track.createRecord()

    it 'should tell the path to clear', ->
      @track.clearPath()

      (expect @pathMock.clear).toHaveBeenCalled()

    it 'should update the raphael path', ->
      @track.set 'raphaelPath', 'somePathValue'
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
      @track = Track.createRecord()

    it 'should tell the path to clean itself', ->
      @track.cleanPath()

      (expect @pathMock.clean).toHaveBeenCalled()

    it 'should update the raphael path', ->
      raphaelPathObserver = sinon.spy()

      @track.addObserver 'raphaelPath', raphaelPathObserver
      @track.cleanPath()

      (expect raphaelPathObserver).toHaveBeenCalled()



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
      @pathMock.getTotalLength = sinon.stub().returns @fakePathLength
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
      @pathMock.getTotalLength = sinon.stub().returns @fakePathLength
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
