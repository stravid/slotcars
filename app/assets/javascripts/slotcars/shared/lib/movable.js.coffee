
#= require helpers/math/vector

Vector = helpers.math.Vector

(namespace 'slotcars.shared.lib').Movable = Ember.Mixin.create

  position: x: 0, y: 0
  rotation: 0
  torque: 0

  moveTo: (newPosition) ->
    previousPosition = @get 'position'

    @set 'position', newPosition

    if @get 'isCrashing'
      @set 'rotation', (@rotation + @torque)
      @torque *= 0.9
    else
      direction = Vector.create from: previousPosition, to: newPosition
      angle = direction.clockwiseAngle()
      @torque = angle - @rotation
      @set 'rotation', angle

