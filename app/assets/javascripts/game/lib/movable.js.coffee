
#= require helpers/namespace
#= require helpers/math/vector

namespace 'game.lib'

Vector = helpers.math.Vector

game.lib.Movable = Ember.Object.extend

  position: x:0, y:0
  rotation: 0
  direction: (Vector.create x:0, y:0)

  speed: 0
  maxSpeed: 0

  acceleration: 0
  deceleration: 0

  update: ->
    @position =
      x: @direction.x * @speed
      y: @direction.y * @speed

    # calculate rotation in relation to up-vector
    rootVector = Vector.create x: 0, y: -1

    @rotation = rootVector.angleFrom @direction

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  decelerate: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0