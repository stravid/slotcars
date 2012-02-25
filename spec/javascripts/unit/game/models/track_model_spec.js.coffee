
#= require game/models/track_model

describe 'game.models.TrackModel', ->

  TrackModel = game.models.TrackModel

  it 'should be a model', ->
    (expect DS.Model.detect TrackModel).toBe true

  beforeEach ->
    @trackPath = 'M10,20L30,40'
    @trackModel = TrackModel._create
      path: @trackPath
  
  describe '#getTotalLength', ->

    it 'should calculate total length of path', ->
      (expect @trackModel.get 'totalLength').toBe Raphael.getTotalLength @trackPath

  describe '#getPointAtLength', ->

    it 'should calculate point at certain length of path', ->
      length = 5
      (expect @trackModel.getPointAtLength length).toEqual Raphael.getPointAtLength @trackPath, length