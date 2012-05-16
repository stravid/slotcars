Shared.Drivable = Ember.Mixin.create

  speed: 0
  maxSpeed: 0

  acceleration: 0
  deceleration: 0

  accelerate: (shouldAccelerate) ->
    if shouldAccelerate
      @set 'speed', (Math.min @maxSpeed, @speed + @acceleration)
    else
      @set 'speed', (Math.max 0, @speed - @deceleration)