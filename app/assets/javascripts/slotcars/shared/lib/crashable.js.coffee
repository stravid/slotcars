
#= require helpers/math/vector
#= require slotcars/shared/lib/movable

Vector = helpers.math.Vector

Shared.Crashable = Ember.Mixin.create

  previousDirection: null
  isCrashing: false

  init: ->
    unless Shared.Movable.detect this
      throw new Error 'Crashable requires Movable'

  checkForCrash: (nextPosition) ->

    direction = Vector.create from: @position, to: nextPosition

    unless @previousDirection?
      @previousDirection = direction
    else
      angle = @previousDirection.angleFrom direction

      if angle * @speed > @traction
        @isCrashing = true
      else
        @previousDirection = direction

  crash: ->
    if @speed == 0
      @isCrashing = false

    crashVector = (@previousDirection.normalize()).scale @speed
    position =
      x: @position.x + crashVector.x
      y: @position.y + crashVector.y

    @moveTo position
