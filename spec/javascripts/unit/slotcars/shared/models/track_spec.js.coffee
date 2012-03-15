
#= require embient/ember-data
#= require slotcars/shared/models/track
#= require helpers/math/path
#= require helpers/math/raphael_path

describe 'slotcars.shared.models.Track', ->

  Track = slotcars.shared.models.Track
  RaphaelPath = helpers.math.RaphaelPath

  it 'should be a subclass of an ember-data Model', ->
    (expect Track).toExtend DS.Model

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
      expectedValue = 'bla'
      @raphaelPathMock.get = sinon.stub().withArgs('totalLength').returns expectedValue

      totalLength = track.getTotalLength()

      (expect totalLength).toBe expectedValue


  describe 'getting point on length of track', ->

    it 'should return the point at specific length on path', ->
      length = 1
      fakePointAtLength = {}
      @raphaelPathMock.getPointAtLength = sinon.stub().withArgs(length).returns fakePointAtLength

      track = Track.createRecord()
      result = track.getPointAtLength length

      (expect result).toBe fakePointAtLength


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
      waits 20
      runs -> (expect @raphaelPathMock.rasterize).toHaveBeenCalled()


  describe 'route to the track resource', ->

    it 'should return the correct route with client id', ->
      track = Track.createRecord()
      id = track.get 'clientId'

      (expect track.get 'playRoute').toEqual "play/#{id}"