
#= require helpers/namespace

#= require game/lib/movable
#= require game/lib/crashable

#= require helpers/math/vector

namespace 'game.lib'

Movable = game.lib.Movable
Crashable = game.lib.Crashable

game.lib.Car = Ember.Object.extend Movable, Crashable,
  
  speed: 0
  maxSpeed: 0

  acceleration: 0
  deceleration: 0

  isCrashing: null
  crashDeceleration: 0

  driveInDirection: (direction) ->
    @previousDirection = @direction
    @direction = direction
    @update()

  crash: ->
    if @speed == 0
      @isCrashing = false

    @decelerate()
    @moveTo {}
    @update()

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  decelerate: ->
    if @isCrashing
      @speed -= @crashDeceleration
    else
      @speed -= @deceleration
    
    if @speed < 0 then @speed = 0


