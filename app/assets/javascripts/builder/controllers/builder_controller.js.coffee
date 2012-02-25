#= require helpers/namespace
#= require helpers/math/vector
#= require helpers/math/path

namespace 'builder.controllers'

Vector = helpers.math.Vector
Path = helpers.math.Path

builder.controllers.BuilderController = Ember.Object.extend

  mediator: null

  onTouchMouseMove: (point) ->
    point.angle = null
    @mediator.points.push point

    @_checkIfAnglesNeedToBeRecalculated()

  onTouchMouseUp: (event) ->

    path = Path.create points: @mediator.points
    path.clean minAngle: 6, minLength: 10, maxLength: 40

    @mediator.points = path.asPointArray()

    for point in @mediator.points
      console.log point.angle


  _calculateAngle: (previous, current, next) ->
    vectorA = Vector.create
      from: current
      to: previous

    vectorB = Vector.create
      from: current
      to: next

    180 - vectorA.angleFrom vectorB

  _checkIfAnglesNeedToBeRecalculated: ->
    @_recalculateAngles() if @mediator.points.length > 2

  _recalculateAngles: ->
    # recalculate first point
    previous = @mediator.points[@mediator.points.length - 1]
    current = @mediator.points[0]
    next = @mediator.points[1]

    angle = @_calculateAngle previous, current, next
    @mediator.points[0].angle = angle

    # recalculate last point
    previous = @mediator.points[@mediator.points.length - 2]
    current = @mediator.points[@mediator.points.length - 1]
    next = @mediator.points[0]

    angle = @_calculateAngle previous, current, next
    @mediator.points[@mediator.points.length - 1].angle = angle

    # recalculate penultimate point
    previous = @mediator.points[@mediator.points.length - 3]
    current = @mediator.points[@mediator.points.length - 2]
    next = @mediator.points[@mediator.points.length - 1]

    angle = @_calculateAngle previous, current, next
    @mediator.points[@mediator.points.length - 2].angle = angle
