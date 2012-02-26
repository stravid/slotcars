#= require helpers/namespace
#= require helpers/math/vector
#= require helpers/math/path

#= require shared/model_store
#= require shared/models/track_model

#= require builder/mediators/builder_mediator
#= require shared/mediators/current_track_mediator

namespace 'builder.controllers'

Vector = helpers.math.Vector

builder.controllers.BuilderController = Ember.Object.extend

  builderMediator: builder.mediators.builderMediator
  currentTrackMediator: shared.mediators.currentTrackMediator
  pointsPath: null

  init: ->
    @pointsPath = helpers.math.Path.create()

  onTouchMouseMove: (point) ->
    point.angle = null
    @pointsPath.push point, true

  onTouchMouseUp: (event) ->
    @pointsPath.clean minAngle: 3, minLength: 10, maxLength: 20
    @pointsPath.smooth 25

    @builderMediator.points = @pointsPath.asPointArray()
    track = shared.ModelStore.createRecord shared.models.TrackModel
    track.setPointArray @builderMediator.points

    @currentTrackMediator.set 'currentTrack', track

  resetPath: ->
    @pointsPath.clear()
    @builderMediator.points = []
