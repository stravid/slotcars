
Shared.Steerable = Ember.Mixin.create

  steeringOffset: 0
  angleSpeedRecords: null # moving average of angle speeds
  maxAngleSpeedRecords: 20

  movingAverageAngleSpeed: 0
  nextMovingAverageAngleSpeed: 0

  steeringFactor: 1.1
  steeringBackFactor: 1.05

  offRoadThreshold: 25
  offRoadFriction: 0
  offRoadSlowDownFactor: 100
  offRoadFrictionMinimizerFactor: 1.05

  DIRECTION_SEARCH_DISTANCE: 20

  LEFT_CURVE_SIGN: 1
  RIGHT_CURVE_SIGN: -1

  init: ->
    @_super()
    @angleSpeedRecords = Shared.LinkedList.create()

  onNextDirectionUpdate: (->
    return unless @direction? and @nextDirection?
    angle = @direction.angleFrom @nextDirection

    @angleSpeedRecords.push angleSpeed: @speed * angle

    @calculateMovingAverageAngleSpeed()

    if @nextMovingAverageAngleSpeed > @movingAverageAngleSpeed then @moveCarOut() else @moveCarIn()

    @applyOffRoadFriction()

    @set 'movingAverageAngleSpeed', @nextMovingAverageAngleSpeed
  ).observes 'nextDirection'

  moveCarOut: ->
    angleSpeedDelta = @nextMovingAverageAngleSpeed - @movingAverageAngleSpeed
    @set 'steeringOffset', @steeringOffset + angleSpeedDelta * @steeringFactor * @getDirectionSign()

  moveCarIn: ->
    angleSpeedDelta = @movingAverageAngleSpeed - @nextMovingAverageAngleSpeed
    @set 'steeringOffset', @steeringOffset / @steeringBackFactor

  getDirectionSign: ->
    firstFuturePosition = @track.getPointAtLength @nextLengthAtTrack + @DIRECTION_SEARCH_DISTANCE
    firstFutureDirection = Shared.Vector.create from: @nextPosition, to: firstFuturePosition

    secondFuturePosition = @track.getPointAtLength @nextLengthAtTrack + @DIRECTION_SEARCH_DISTANCE * 2
    secondFutureDirection = Shared.Vector.create from: firstFuturePosition, to: secondFuturePosition

    angle = firstFutureDirection.relativeClockwiseAngleTo secondFutureDirection

    if angle > 0 then return @LEFT_CURVE_SIGN else return @RIGHT_CURVE_SIGN

  calculateMovingAverageAngleSpeed: ->
    currentRecord = @angleSpeedRecords.tail
    totalAngleSpeed = 0

    while currentRecord
      totalAngleSpeed += currentRecord.angleSpeed
      currentRecord = currentRecord.previous

    @set 'nextMovingAverageAngleSpeed', totalAngleSpeed / @angleSpeedRecords.length

    @angleSpeedRecords.remove @angleSpeedRecords.head if @angleSpeedRecords.length > @maxAngleSpeedRecords

  applyOffRoadFriction: ->
    currentOffRoadFriction = Math.max 0, @nextMovingAverageAngleSpeed - @offRoadThreshold

    console.log (@speed / @offRoadSlowDownFactor) * @offRoadFriction

    (@set 'offRoadFriction', currentOffRoadFriction) if currentOffRoadFriction > @offRoadFriction

    @set 'speed', @speed - (@speed / @offRoadSlowDownFactor) * @offRoadFriction
    @set 'offRoadFriction', Math.max 0, @offRoadFriction / @offRoadFrictionMinimizerFactor