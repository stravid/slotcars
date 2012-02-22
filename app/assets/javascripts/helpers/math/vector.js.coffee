
#= require helpers/namespace

namespace 'helpers.math'

class helpers.math.Vector

  constructor: (point) ->
    @x = point.x
    @y = point.y

  length: ->
    Math.sqrt (@x*@x) + (@y*@y)

  dot: (otherVector) ->
    @x * otherVector.x + @y * otherVector.y

  # returns angle in radian
  angleFrom: (otherVector) ->
    theta = @dot(otherVector) / (@length() * otherVector.length())

    if theta < -1 then theta = -1
    if theta > 1 then theta = 1

    Math.acos theta