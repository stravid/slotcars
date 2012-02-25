#= require helpers/namespace
#= require helpers/math/vector

namespace 'builder.controllers'

Vector = helpers.math.Vector

builder.controllers.BuilderController = Ember.Object.extend

  mediator: null

  onTouchMouseMove: (point) ->
    point.angle = null
    @mediator.points.push point

    @_checkIfAnglesNeedToBeRecalculated()

  _calculateAngle: (previous, current, next) ->
    vectorA = Vector.create
      from: current
      to: previous

    vectorB = Vector.create
      from: current
      to: next

    vectorA.angleFrom vectorB

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
