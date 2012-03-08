
#= require shared/models/track_model
#= require helpers/math/path

describe 'shared.models.TrackModel', ->

  TrackModel = shared.models.TrackModel

  it 'should be a model', ->
    (expect TrackModel).toExtend DS.Model

  beforeEach ->
    @path = helpers.math.Path.create points: [
      {x: 0, y:0, angle: 0}
      {x: 1, y:0, angle: 0}
      {x: 1, y:1, angle: 0}
      {x: 0, y:1, angle: 0}
    ]

    @trackModel = TrackModel.createRecord()
    @trackModel.setPointPath @path
  
  describe '#getTotalLength', ->

    it 'should calculate total length of path', ->
      (expect @trackModel.get 'totalLength').toBe @path.getTotalLength()

  describe '#getPointAtLength', ->

    it 'should calculate point at certain length of path', ->
      length = 5
      (expect @trackModel.getPointAtLength length).toEqual @path.getPointAtLength length