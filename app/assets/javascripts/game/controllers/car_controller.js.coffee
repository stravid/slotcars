
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
    @_updateCarPosition()
    @_updateTrackLength()

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  slowDown: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0

  drive: ->
    @_checkCrashThreshold()
    @lengthAtTrack += @speed
    @_updateCarPosition()

    if @lengthAtTrack > @trackLength
      ($ this).trigger 'crossFinishLine'

  reset: ->
    @speed = 0
    @lengthAtTrack = 0
    @_updateCarPosition()

  _updateTrackLength: ->
    @trackLength = Raphael.getTotalLength @path

  _updateCarPosition: ->
    point = Raphael.getPointAtLength @path, @lengthAtTrack

    @mediator.set 'position',
      x: point.x
      y: point.y

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

    curving = 180 - angle

    if curving * @speed > @traction then @crashing = true

