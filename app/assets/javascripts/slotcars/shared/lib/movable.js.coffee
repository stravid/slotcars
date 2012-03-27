
#= require helpers/math/vector

Vector = helpers.math.Vector

(namespace 'slotcars.shared.lib').Movable = Ember.Mixin.create

  position: x: 0, y: 0
  bouncePosition: null
  oldTailPosition: null
  rotation: 0
  torque: 0
  
  # constants for bounce calculation
  INERTIA: 0.8
  OFFSET: 0.1
  K: 0.12
  
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
      @angle = staticAngle
      @oldTailPosition = tailPosition
      
      @set 'rotation', newAngle

  resetMovable: ->
    @bouncePosition = null
    @oldTailPosition = null
    @driftValue = x: 0, y: 0
  
  _calculateTorque: (newAngle) ->
    torque = (newAngle - @angle) * 3 * @_relativeSpeed()
    torque or= 0
    
  _calculateBouncePosition: (position) ->
    inertia = @_calculateSpeedFactor()
    
    x = position.x - @bouncePosition.x
    y = position.y - @bouncePosition.y
    
    @driftValue.x = @driftValue.x * inertia + x * @K
    @driftValue.y = @driftValue.y * inertia + y * @K
  
    @bouncePosition.x += @driftValue.x
    @bouncePosition.y += @driftValue.y
  
  _relativeSpeed: ->
    @speed / @maxSpeed
  
  _calculateSpeedFactor: ->
    value = @_relativeSpeed()
    return 0.5 if value < 0.1
    return @INERTIA + @OFFSET if value > 0.6 
    @INERTIA + value * @OFFSET
    