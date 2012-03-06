
#= require helpers/namespace
#= require helpers/math/vector
#= require game/lib/movable

namespace 'game.lib'

Vector = helpers.math.Vector
Movable = game.lib.Movable

game.lib.Crashable = Ember.Mixin.create

  previousDirection: null
  isCrashing: false

  init: ->
    unless Movable.detect this
      throw new Error 'Crashable requires Movable'

  checkForCrash: (nextPosition) ->

    direction = Vector.create from: @position, to: nextPosition

    unless @previousDirection?
      @previousDirection = direction
    else
      angle = @previousDirection.angleFrom direction
      @previousDirection = direction

      if angle * @speed > @traction
        @isCrashing = true

  crash: ->
    if @speed == 0
      @isCrashing = false
      @speed = @deceleration + 0.01

    crashVector = (@previousDirection.normalize()).scale @speed
    position =
      x: @position.x + crashVector.x
      y: @position.y + crashVector.y

    @moveTo position
