Shared.Crashable = Ember.Mixin.create

  traction: 0
  crashDeceleration: 0

  direction: null
  nextDirection: null

  isCrashing: false

  # properties for crashing animation
  torque: 0
  torqueMinimizeMultiplier: 0.94

  init: ->
    @_super()
    throw new Error 'Crashable requires Movable' unless Shared.Movable.detect this
    throw new Error 'Crashable requires Drivable' unless Shared.Drivable.detect this

  checkForCrash: ->
    @set 'nextDirection', Shared.Vector.create from: @position, to: @getNextPosition()

    unless @direction?
      @set 'direction', @nextDirection
    else
      if @isTooFastInCurve()
        @crash()
      else
        @updateDirection()
        @updateTorque()

  crash: -> @set 'isCrashing', true

  moveCarInCrashingDirection: ->
    @checkForCrashEnd()
    @slowDownCrashingCar()
    @rotateCrashingCar()

    @set 'position', @calculateNextCrashingPosition @getCrashVector()

  isTooFastInCurve: () ->
    return false if @speed <= 0

    angle = @direction.angleFrom @nextDirection
    speedPercentageMultiplier = (@speed / @maxSpeed) + 1

    if (angle * speedPercentageMultiplier) + (@speed * speedPercentageMultiplier) > @traction then true else false

  updateDirection: -> @direction = @nextDirection

  slowDownCrashingCar: ->
    @set 'speed', @speed - @crashDeceleration
    @clampMinSpeed()

  checkForCrashEnd: -> (@set 'isCrashing', false) if @speed <= 0

  getCrashVector: -> (@direction.normalize()).scale @speed

  calculateNextCrashingPosition: (crashVector) ->
    {
      x: @position.x + crashVector.x
      y: @position.y + crashVector.y
    }

  updateTorque: -> @set 'torque', (@getNextRotation() - @rotation) * 3 * @relativeSpeed()

  relativeSpeed: -> @speed / @maxSpeed

  rotateCrashingCar: ->
    @set 'rotation', (@rotation + @torque)
    @reduceTorque()

  reduceTorque: -> @set 'torque', @torque *= @torqueMinimizeMultiplier