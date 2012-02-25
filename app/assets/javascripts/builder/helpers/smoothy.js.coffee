
#= require helpers/namespace
#= require helpers/math/vector

namespace 'builder.helpers'

Vector = helpers.math.Vector

class builder.helpers.Smoothy

  @smooth: (points, angleThreshold) ->

    interpolatedPoints = []
    dirty = false

    for point, i in points
      if point.angle > angleThreshold and not dirty

        start = if i-1 >= 0 then points[i-1] else points[points.length - 1]
        middle = point
        end = points[(i+1) % points.length]

        brokenPoints = @_breakDown start, middle, end

        interpolatedPoints.push brokenPoints[0]
        interpolatedPoints.push brokenPoints[1]

        dirty = true

      else
        interpolatedPoints.push point


    if dirty
      return @smooth interpolatedPoints, angleThreshold
    else
      return interpolatedPoints

  @_breakDown: (startPoint, middlePoint, endPoint) ->
    vectorA = Vector.create from: startPoint, to: middlePoint
    vectorB = Vector.create from: middlePoint, to: endPoint

    interpolatedA =
      x: startPoint.x + vectorA.center().x
      y: startPoint.y + vectorA.center().y

    interpolatedB =
      x: middlePoint.x + vectorB.center().x
      y: middlePoint.y + vectorB.center().y

    interpolatedA.angle = @_angle startPoint, interpolatedA, interpolatedB
    interpolatedB.angle = @_angle interpolatedA, interpolatedB, endPoint

    [
      interpolatedA
      interpolatedB
    ]

  @_angle: (a, b, c) ->
    vector1 = Vector.create from: a, to: b
    vector2 = Vector.create from: b, to: c

    vector1.angleFrom vector2