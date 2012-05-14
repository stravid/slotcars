Shared.Drivable = Ember.Mixin.create

  speed: 0
  maxSpeed: 0

  acceleration: 0
  deceleration: 0

  offRoadThreshold: 0
  offRoadFriction: 0

  speedMultiplierForOffroadFriction: 2
  angleFractionForOffroadFriction: 3

  speedSlowDownFactor: 200
  offRoadFrictionMinimizerFactor: 1.2

  accelerate: (shouldAccelerate) ->
    if shouldAccelerate
      @set 'speed', @speed + @acceleration
    else
      @set 'speed', @speed - @deceleration

    @clampMinSpeed()
    @clampMaxSpeed()

  calculateOffRoadFriction: (->
    return unless @direction? and @nextDirection?
    angle = @direction.angleFrom @nextDirection

    speedRatio = (@speed * @speedMultiplierForOffroadFriction)
    angleRatio = (angle / @angleFractionForOffroadFriction)

    currentOffRoadFriction = speedRatio * angleRatio - @offRoadThreshold
    (@set 'offRoadFriction', currentOffRoadFriction) if currentOffRoadFriction > @offRoadFriction

    @set 'speed', @speed - (@speed / @speedSlowDownFactor) * @offRoadFriction
    @set 'offRoadFriction', Math.max 0, @offRoadFriction / @offRoadFrictionMinimizerFactor

  ).observes 'nextDirection'

  clampMinSpeed: -> if @speed < 0 then @set 'speed', 0

  clampMaxSpeed: -> if @speed > @maxSpeed then @set 'speed', @maxSpeed
