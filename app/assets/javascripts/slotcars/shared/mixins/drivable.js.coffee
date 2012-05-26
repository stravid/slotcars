Shared.Drivable = Ember.Mixin.create

  speed: 0
  maxSpeed: 0

  acceleration: 0
  deceleration: 0

  accelerate: (shouldAccelerate) ->
    if shouldAccelerate
      @set 'speed', @speed + @acceleration
    else
      @set 'speed', @speed - @deceleration

    @clampMinSpeed()
    @clampMaxSpeed()

  clampMinSpeed: -> if @speed < 0 then @set 'speed', 0

  clampMaxSpeed: -> if @speed > @maxSpeed then @set 'speed', @maxSpeed
