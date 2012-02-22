
#= require helpers/namespace
#= require vendor/raphael
#= require helpers/math/vector

namespace 'game.controllers'

Vector = helpers.math.Vector

@game.controllers.CarController = Ember.Object.extend

  speed: 0
  lengthAtTrack: 0
  path: null
  crashing: false

  setTrackPath: (@path) ->
    @lengthAtTrack = 0
    @_calculatePositionOnPath()
    @_updateCarPosition()
    @_updateTrackLength()

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  slowDown: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0

  drive: ->
    unless @crashing
      if @speed > 0 then @_checkCrashThreshold()

      @lengthAtTrack += @speed
      @_calculatePositionOnPath()
      @_updateCarPosition()

      if @lengthAtTrack > @trackLength
        ($ this).trigger 'crossFinishLine'

    else
      @_calculateCrashingDirection()
      @_updateCarPosition()

  reset: ->
    @speed = 0
    @lengthAtTrack = 0
    @_updateCarPosition()

  _updateTrackLength: ->
    @trackLength = Raphael.getTotalLength @path

  _calculateCrashingDirection: ->
    @_position.x += @_crashVector.x / @_crashVector.length() * @speed
    @_position.y += @_crashVector.y / @_crashVector.length() * @speed

  _calculatePositionOnPath: ->
    @_position = Raphael.getPointAtLength @path, @lengthAtTrack

  _updateCarPosition: ->
    @mediator.set 'position',
      x: @_position.x
      y: @_position.y

  _getNextVectors: ->
    pointA = Raphael.getPointAtLength @path, @lengthAtTrack
    pointB = Raphael.getPointAtLength @path, @lengthAtTrack + @speed
    pointC = Raphael.getPointAtLength @path, @lengthAtTrack + @speed * 2

    {
      first: (new Vector pointA, pointB)
      second: (new Vector pointB, pointC)
    }

  _checkCrashThreshold: ->
    vectors = @_getNextVectors()

    angle = vectors.first.angleFrom vectors.second

    if angle > 180 then angle = 360 - angle

    if angle * @speed > @traction
      @_crashVector = vectors.first
      @crashing = true

