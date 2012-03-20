
class namespace('helpers.math').Vector

  constructor: (@x, @y) ->

  length: -> Math.sqrt (@x*@x) + (@y*@y)

  dot: (otherVector) -> @x * otherVector.x + @y * otherVector.y

  # returns angle in degrees
  angleFrom: (otherVector) ->
    theta = @dot(otherVector) / (@length() * otherVector.length())

    if theta < -1 then theta = -1
    if theta > 1 then theta = 1

    degrees = Math.acos(theta) * 180 / Math.PI

  clockwiseAngle: ->
    upVector = Vector.create x: 0, y: -1
    angle = upVector.angleFrom this

    if @x < 0 then 360 - angle else angle

  center: ->
    new Vector @x/2, @y/2

  normalize: ->
    new Vector @x/@length(), @y/@length()

  scale: (factor) ->
    new Vector @x*factor, @y*factor

  @create: (parameters) ->
    if parameters.x? and parameters.y?
      x = parameters.x
      y = parameters.y
    else
      x = parameters.to.x - parameters.from.x
      y = parameters.to.y - parameters.from.y

    new Vector x, y