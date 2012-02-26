#= require helpers/namespace
#= require helpers/math/vector
#= require helpers/math/path

#= require shared/model_store
#= require shared/models/track_model

namespace 'builder.controllers'

Vector = helpers.math.Vector

builder.controllers.BuilderController = Ember.Object.extend

  trackMediator: null
  pointsPath: null

  init: ->
    @pointsPath = helpers.math.Path.create()

  onTouchMouseMove: (point) ->
    point.angle = null
    @pointsPath.push point, true

  onTouchMouseUp: (event) ->
    @pointsPath.clean minAngle: 3, minLength: 10, maxLength: 20
    @pointsPath.smooth 25

    @trackMediator.points = @pointsPath.asPointArray()
    track = shared.ModelStore.createRecord shared.models.TrackModel
    track.setPointArray @trackMediator.points

    @trackMediator.set 'builtTrack', track


  resetPath: ->
    @pointsPath.clear()
    @trackMediator.points = []
