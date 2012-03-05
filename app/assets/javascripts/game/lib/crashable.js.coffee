
#= require helpers/namespace
#= require helpers/math/vector

#= require game/lib/movable

namespace 'game.lib'

Movable = game.lib.Movable
Vector = helpers.math.Vector

game.lib.Crashable = Ember.Mixin.create
    
  isCrashing: false

  checkForCrash: (nextPosition) ->

    if @previousDirection?
      direction = Vector.create from: @position, to: nextPosition
      angle = @previousDirection.angleFrom direction
      @previousDirection = direction

      if angle * @speed > @traction
        @isCrashing = true

  crash: ->
    if @speed == 0
      @isCrashing = false

    @decelerate()

