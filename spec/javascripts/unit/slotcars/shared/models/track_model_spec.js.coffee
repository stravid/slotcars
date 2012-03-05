
#= require embient/ember-data
#= require slotcars/shared/models/track_model
#= require helpers/math/path

describe 'slotcars.shared.models.TrackModel', ->

  TrackModel = slotcars.shared.models.TrackModel

  it 'should be a subclass of an ember-data Model', ->
    (expect DS.Model.detect TrackModel).toBe true

  beforeEach ->
    @PathMock = mockEmberClass helpers.math.Path,
      push: sinon.spy()
      asPointArray: sinon.stub().returns [ x: 1, y: 0 ]

  afterEach ->
    @PathMock.restore()

  describe 'adding path points', ->

    it 'should push point into its path', ->
      track = TrackModel.createRecord()

      testPoint = x: 0, y: 0
      track.addPathPoint testPoint

      (expect @PathMock.push).toHaveBeenCalledWith testPoint, true

  describe 'raphael path', ->

    beforeEach ->
      @track = TrackModel.createRecord()

    it 'should be an valid empty path with a single move to command', ->
      (expect @track.get 'raphaelPath').toEqual 'M0,0Z'

    it 'should update the raphael path when first point added', ->
      @track.addPathPoint x: 1, y: 0

      (expect @track.get 'raphaelPath').toEqual 'M1,0Z'

    it 'should update raphael path correctly when multiple points were added', ->
      @firstPoint = { x: 1, y: 0 }
      @secondPoint = { x: 2, y: 1 }
      @thirdPoint = { x: 3, y: 2 }

      @PathMock.asPointArray.returns [ @firstPoint, @secondPoint, @thirdPoint ]

      @track.addPathPoint @firstPoint
      @track.addPathPoint @secondPoint
      @track.addPathPoint @thirdPoint

      (expect @track.get 'raphaelPath').toEqual 'M1,0L2,1L3,2Z'


  describe 'getting total length of path', ->

    it 'should return the paths current total lenght', ->
      fakeTotalLength = 1
      @PathMock.getTotalLength = -> return fakeTotalLength

      @track = TrackModel.createRecord()

      (expect @track.getTotalLength()).toEqual fakeTotalLength


  describe 'getting point on length of track', ->

    it 'should return the point at specific length on path', ->
      length = 1
      fakePointAtLength = {}
      @PathMock.getPointAtLength = sinon.stub().withArgs(length).returns fakePointAtLength

      @track = TrackModel.createRecord()
      result = @track.getPointAtLength length

      (expect result).toBe fakePointAtLength