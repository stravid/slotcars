
#= require helpers/namespace
#= require helpers/math/vector

namespace 'game.lib'

Vector = helpers.math.Vector

game.lib.Movable = Ember.Mixin.create

  position: x: 0, y: 0
  rotation: 0

  moveTo: (newPosition) ->
    previousPosition = @get 'position'

    @set 'position', newPosition

    direction = Vector.create from: previousPosition, to: newPosition
    @set 'rotation', direction.clockwiseAngle()

