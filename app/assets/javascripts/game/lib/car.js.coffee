
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
  crashDeceleration: 0

  isCrashing: null

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  decelerate: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0

  crashcelerate: ->
    @speed -= @crashDeceleration
    if @speed < 0 then @speed = 0
