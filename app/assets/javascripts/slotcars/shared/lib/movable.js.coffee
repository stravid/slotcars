
#= require helpers/math/vector

Vector = helpers.math.Vector

(namespace 'slotcars.shared.lib').Movable = Ember.Mixin.create

  position: x: 0, y: 0
  bouncePosition: null
  oldTailPosition: null
  rotation: 0
  torque: 0
  
  inertia: 0.89
  k: 0.19
  xp: 0
  yp: 0

  moveTo: (newPosition, tailPosition) ->
    previousPosition = @get 'position'

    @set 'position', newPosition

    if @get 'isCrashing'
      @set 'rotation', (@rotation + @torque)
      @torque *= 0.94
      @bouncePosition = null
    else
      unless tailPosition
        @bouncePosition = @oldTailPosition
        @xp = 0
        @yp = 0
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

  _calculateTorque: (newAngle) ->
    torque = (newAngle - @angle) * 3
    torque or= 0
    
  _calculateBouncePosition: (position) ->
    x = position.x - @bouncePosition.x
    y = position.y - @bouncePosition.y
    
    @xp = @xp * @inertia + x*@k
    @yp = @yp * @inertia + y*@k
  
    @bouncePosition.x += @xp
    @bouncePosition.y += @yp
    