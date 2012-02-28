
#= require helpers/namespace
#= require game/lib/movable

#= require helpers/math/vector

namespace 'game.lib'

game.lib.Car = game.lib.Movable.extend
  
  isCrashing: false
  previousDirection: null

  checkForCrash: ->
    if @previousDirection?
      angle = @previousDirection.angleFrom @direction

      if angle * @speed > @traction
        @isCrashing = true

  driveInDirection: (direction) ->
    @previousDirection = @direction
    @direction = direction
    @update()

