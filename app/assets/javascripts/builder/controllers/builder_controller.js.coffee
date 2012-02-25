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
    @pointsPath.clean minAngle: 6, minLength: 30, maxLength: 50
    @pointsPath.smooth 30

    @trackMediator.points = @pointsPath.asPointArray()

  resetPath: ->
    @pointsPath.clear()
    @trackMediator.points = []
