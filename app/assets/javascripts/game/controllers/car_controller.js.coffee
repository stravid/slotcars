
#= require helpers/namespace
#= require vendor/raphael
#= require helpers/math/vector

#= require game/mediators/car_mediator
#= require shared/mediators/current_track_mediator

namespace 'game.controllers'

Vector = helpers.math.Vector

game.controllers.CarController = Ember.Object.extend

  speed: 0
  maxSpeed: 1
  acceleration: 0
  deceleration: 0

  trackLength: 0
  lengthAtTrack: 0

  crashing: false

  carMediator: game.mediators.carMediator
  trackMediator: shared.mediators.currentTrackMediator

  setup: ->
    @_calculatePositionOnPath()
    @_updateCarPosition()
    @_updateTrackLength()

  # accelerate: ->
  #   unless @crashing
  #     @speed += @acceleration
  #     if @speed > @maxSpeed then @speed = @maxSpeed

  # slowDown: ->
  #   unless @crashing
  #     @speed -= @deceleration
  #     if @speed < 0 then @speed = 0

  drive: -> unless @crashing then @_driveOnPath() else @_crash()

  reset: ->
    @speed = 0
    @lengthAtTrack = 0
    @_updateCarPosition()

  _driveOnPath: ->
    if @speed > 0 then @_checkCrashThreshold()

    @lengthAtTrack += @speed
    @_calculatePositionOnPath()
    @_updateCarPosition()
    @_calculateRotation()
    @_checkForFinish()

  _crash: ->
    if @speed <= 0
      @crashing = false
    else
      @_slowDownOffRoad()
      @_calculateCrashingDirection()
      @_updateCarPosition()

  # _slowDownOffRoad: ->
  #   @speed -= @offRoadDeceleration
  #   if @speed < 0 then @speed = 0

  # _checkForFinish: ->
  #   if @lengthAtTrack > @trackLength
  #     (jQuery this).trigger 'crossFinishLine'

  # _updateTrackLength: -> @trackLength = @trackMediator.currentTrack.get 'totalLength'

  # _calculateCrashingDirection: ->
  #   @_position.x += @_crashVector.x / @_crashVector.length() * @speed
  #   @_position.y += @_crashVector.y / @_crashVector.length() * @speed

  # _calculatePositionOnPath: ->
  #   @_position = @_getPointAtLength @lengthAtTrack

  # _getPointAtLength: (length) ->
  #   @trackMediator.currentTrack.getPointAtLength length

  # _calculateRotation: ->
  #   currentPosition = @_getPointAtLength @lengthAtTrack
  #   nextPosition = @_getPointAtLength @lengthAtTrack + @speed
  # 
  #   carVector = (Vector.create from: currentPosition, to: nextPosition)
  # 
  #   carAngle = carVector.clockwiseAngle()
  # 
  #   unless isNaN carAngle
  #     @carMediator.set 'rotation', carAngle

  # _updateCarPosition: ->
  #   @carMediator.set 'position',
  #     x: @_position.x
  #     y: @_position.y
  # 
  # _getNextPathVectors: ->
  #   pointA = @_getPointAtLength @lengthAtTrack
  #   pointB = @_getPointAtLength @lengthAtTrack + @speed
  #   pointC = @_getPointAtLength @lengthAtTrack + @speed * 2
  # 
  #   {
  #     first: (Vector.create from: pointA, to: pointB)
  #     second: (Vector.create from: pointB, to: pointC)
  #   }
  # 
  # _checkCrashThreshold: ->
  #   vectors = @_getNextPathVectors()
  # 
  #   angle = vectors.first.angleFrom vectors.second
  # 
  #   if angle > 180 then angle = 360 - angle
  # 
  #   if angle * @speed > @traction
  #     @_crashVector = vectors.first
  #     @crashing = true
  # 
