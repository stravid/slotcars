
Shared.Vector = Ember.Object.extend

  x: null
  y: null
  from: null
  to: null

  init: ->
    @_super()

    if @from? and @to?
      @x = @to.x - @from.x
      @y = @to.y - @from.y

  length: -> Math.sqrt (@x*@x) + (@y*@y)

  dot: (otherVector) -> @x * otherVector.x + @y * otherVector.y

  # returns angle in degrees
  angleFrom: (otherVector) ->
    theta = @dot(otherVector) / (@length() * otherVector.length())

    if theta < -1 then theta = -1
    if theta > 1 then theta = 1

    degrees = Math.acos(theta) * 180 / Math.PI

  clockwiseAngle: ->
    upVector = Shared.Vector.create x: 0, y: -1
    angle = upVector.angleFrom this

    if @x < 0 then 360 - angle else angle

  center: ->
    Shared.Vector.create
      x: @x / 2
      y: @y / 2

  normalize: ->
    Shared.Vector.create
      x: @x / @length()
      y: @y / @length()

  scale: (factor) ->
    Shared.Vector.create
      x: @x * factor
      y: @y * factor
