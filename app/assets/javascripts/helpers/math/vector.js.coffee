
#= require helpers/namespace

namespace 'helpers.math'

class helpers.math.Vector

  constructor: (@x, @y) ->

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

  # ember like static constructor method
  # that takes an literal with eiter 'x' and 'y'
  # or two points 'from' and 'to'
  @create: (parameters) ->
    if parameters.x? and parameters.y?
      x = parameters.x
      y = parameters.y
    else
      x = parameters.to.x - parameters.from.x
      y = parameters.to.y - parameters.from.y

    new Vector x, y