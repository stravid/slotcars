
#= require helpers/namespace
#= require helpers/math/vector

namespace 'game.lib'

Vector = helpers.math.Vector

game.lib.Crashable = Ember.Mixin.create

  previousDirection: null
  isCrashing: false

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