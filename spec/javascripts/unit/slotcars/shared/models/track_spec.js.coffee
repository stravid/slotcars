
#= require embient/ember-data
#= require slotcars/shared/models/track
#= require helpers/math/path
#= require helpers/math/raphael_path

describe 'slotcars.shared.models.Track', ->

  Track = slotcars.shared.models.Track
  RaphaelPath = helpers.math.RaphaelPath

  it 'should be a subclass of an ember-data Model', ->
    (expect Track).toExtend DS.Model

  it 'should define a url', ->
    (expect Track.url).toBeDefined()

  beforeEach ->
    @raphaelPathMock = mockEmberClass RaphaelPath

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

    it 'should rasterize the raphael path after an short delay', ->
      runs -> @track.cleanPath()
      waits 200
      runs -> (expect @raphaelPathMock.rasterize).toHaveBeenCalled()


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
