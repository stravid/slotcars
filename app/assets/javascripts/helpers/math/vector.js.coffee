
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
    (Math.acos @dot(otherVector) / (@length() * otherVector.length()))