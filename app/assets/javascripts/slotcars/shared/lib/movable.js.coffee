
#= require helpers/math/vector

Vector = helpers.math.Vector

(namespace 'slotcars.shared.lib').Movable = Ember.Mixin.create

  position: x: 0, y: 0
  bouncePosition: null
  oldTailPosition: null
  rotation: 0
  torque: 0
  
  # constants for bounce calculation
  INERTIA: 0.885
  K: 0.1
  
  # current drift
  driftValue: x: 0, y: 0

  moveTo: (newPosition, tailPosition) ->
    previousPosition = @get 'position'

    @set 'position', newPosition

    if @get 'isCrashing'
      @set 'rotation', (@rotation + @torque)
      @torque *= 0.94
      @bouncePosition = null
    else
      unless tailPosition
        return unless @oldTailPosition
        @bouncePosition = @oldTailPosition
        @driftValue = x: 0, y: 0
      else
        unless @bouncePosition
          @bouncePosition = tailPosition 
        else 
          @_calculateBouncePosition tailPosition
      
      direction = Vector.create from: @bouncePosition, to: newPosition
      newAngle = direction.clockwiseAngle()
      
      staticDirection = Vector.create from: previousPosition, to: newPosition
      staticAngle = staticDirection.clockwiseAngle()
      
      @torque = @_calculateTorque staticAngle

      @set 'rotation', newAngle
      @set 'angle', staticAngle
      
      @oldTailPosition = tailPosition

  resetMovable: ->
    @bouncePosition = null
    @oldTailPosition = null
    @driftValue = x: 0, y: 0
  
  _calculateTorque: (newAngle) ->
    torque = (newAngle - @angle) * 3
    torque or= 0
    
  _calculateBouncePosition: (position) ->
    x = position.x - @bouncePosition.x
    y = position.y - @bouncePosition.y
    
    @driftValue.x = @driftValue.x * @INERTIA + x*@K
    @driftValue.y = @driftValue.y * @INERTIA + y*@K
  
    @bouncePosition.x += @driftValue.x
    @bouncePosition.y += @driftValue.y
    