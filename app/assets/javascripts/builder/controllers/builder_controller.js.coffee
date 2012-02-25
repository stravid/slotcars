#= require helpers/namespace
#= require helpers/math/vector
#= require helpers/math/path

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
    @pointsPath.clean minAngle: 6, minLength: 20, maxLength: 40
    @pointsPath.smooth 45
    @pointsPath.clean minAngle: 6, minLength: 20, maxLength: 40

    @trackMediator.points = @pointsPath.asPointArray()
