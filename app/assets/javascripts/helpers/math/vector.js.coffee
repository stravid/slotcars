
#= require helpers/namespace

namespace 'helpers.math'

class helpers.math.Vector

  constructor: () ->
    if arguments.length > 1
      @x = arguments[1].x - arguments[0].x
      @y = arguments[1].y - arguments[0].y
    else
      @x = arguments[0].x
      @y = arguments[0].y

  length: ->
    Math.sqrt (@x*@x) + (@y*@y)

  dot: (otherVector) ->
    @x * otherVector.x + @y * otherVector.y

  # returns angle in radian
  angleFrom: (otherVector) ->
    theta = @dot(otherVector) / (@length() * otherVector.length())

    if theta < -1 then theta = -1
    if theta > 1 then theta = 1

    Math.acos(theta) * 180 / Math.PI