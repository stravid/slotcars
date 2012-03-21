
#= require helpers/math/vector

Vector = helpers.math.Vector

(namespace 'slotcars.shared.lib').Movable = Ember.Mixin.create

  position: x: 0, y: 0
  rotation: 0

  moveTo: (newPosition) ->
    previousPosition = @get 'position'

    @set 'position', newPosition

    direction = Vector.create from: previousPosition, to: newPosition
    @set 'rotation', direction.clockwiseAngle()

