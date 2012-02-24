
#= require game/models/track_model

describe 'game.models.TrackModel', ->

  TrackModel = game.models.TrackModel

  it 'should be a model', ->
    (expect DS.Model.detect TrackModel).toBe true

  beforeEach ->
    @store = DS.Store.create()
    @trackPath = 'M10,20L30,40'
    @trackModel = @store.createRecord TrackModel,
      path: @trackPath
  
  describe '#getTotalLength', ->

    it 'should calculate total length of path', ->
      (expect @trackModel.get 'totalLength').toBe Raphael.getTotalLength @trackPath

  describe '#getPointAtLength', ->

    it 'should calculate point at certain length of path', ->
      length = 5
      (expect @trackModel.getPointAtLength length).toEqual Raphael.getPointAtLength @trackPath, length