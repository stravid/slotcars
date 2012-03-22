
#= require helpers/math/vector

Vector = helpers.math.Vector

(namespace 'slotcars.shared.lib').Movable = Ember.Mixin.create

  position: x: 0, y: 0
  bouncePosition: x: 0, y: 0
  previousPosition: x: 0, y: 0
  rotation: 0
  torque: 0
  angle: 0
  
  inertia: 0.9
  k: 0.1
  xp: 0
  yp: 0

  moveTo: (newPosition) ->
    @previousPosition = @get 'position' unless @_areSame newPosition, (@get 'position')

    @set 'position', newPosition
    @_calculateBouncePosition @previousPosition

    if @get 'isCrashing'
      @set 'rotation', (@rotation + @torque)
      @torque *= 0.94
    else
      @torque = @_calculateTorque newAngle, 'linear'
      
      direction = Vector.create from: @bouncePosition, to: newPosition
      newAngle = direction.clockwiseAngle()

      @set 'rotation', newAngle
      @set 'angle', newAngle

  _areSame: (a, b) ->
    return unless a?
    return unless b?
    
    if a.x is b.x and a.y is b.y 
      true
    else 
      false 

  _calculateTorque: (newAngle, type) ->
    switch type
      when 'linear' then @_linearTorque newAngle
      else @_baseTorque newAngle
  
  _baseTorque: (newAngle) ->
    torque = (newAngle - @angle)
    torque or= 0
  
  _linearTorque: (newAngle) ->
    torque = (newAngle - @angle) * 3
    torque or= 0
  
  _makeValue: (newAngle) ->
    if newAngle > @rotation + 180 then newAngle -= 360
    if newAngle < @rotation - 180 then newAngle += 360
    
    difference = newAngle - @rotation
    
    value = difference
    value = if value < 0 then value + 360 else value
    value %= 360
    value = value * @inertia + difference * @k
    value or= 0
    
  _calculateBouncePosition: (position) ->
    x = position.x - @bouncePosition.x
    y = position.y - @bouncePosition.y
    
    @xp = @xp * @inertia + x*@k
    @yp = @yp * @inertia + y*@k
  
    @bouncePosition.x += @xp
    @bouncePosition.y += @yp
    