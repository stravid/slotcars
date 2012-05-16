Shared.Crashable = Ember.Mixin.create

  traction: 0
  crashDeceleration: 0

  direction: null
  nextDirection: null

  isCrashing: false

  init: ->
    @_super()
    throw new Error 'Crashable requires Movable' unless Shared.Movable.detect this
    throw new Error 'Crashable requires Drivable' unless Shared.Drivable.detect this

  checkForCrash: (->
    @set 'nextDirection', Shared.Vector.create from: @position, to: @nextPosition

    unless @direction?
      @set 'direction', @nextDirection
    else
      if @isTooFastInCurve() then @crash() else @updateDirection()

  ).observes 'nextPosition'

  crash: -> @set 'isCrashing', true

  moveCarInCrashingDirection: ->
    @slowDownCrashingCar()
    @checkForCrashEnd()

    @set 'position', @calculateNextCrashingPosition @getCrashVector()

  isTooFastInCurve: () ->
    angle = @direction.angleFrom @nextDirection
    if angle * @speed > @traction then true else false

  updateDirection: -> @set 'direction', @nextDirection

  slowDownCrashingCar: -> @set 'speed', Math.max 0, @speed - @crashDeceleration

  checkForCrashEnd: -> @set 'isCrashing', false if @speed <= 0

  getCrashVector: -> (@direction.normalize()).scale @speed

  calculateNextCrashingPosition: (crashVector) ->
    {
      x: @position.x + crashVector.x
      y: @position.y + crashVector.y
    }