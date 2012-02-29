
#= require helpers/namespace
#= require game/lib/movable

#= require helpers/math/vector

namespace 'game.lib'

game.lib.Car = game.lib.Movable.extend
  
  isCrashing: false
  previousDirection: null
  offRoadDeceleration: 0

  checkForCrash: ->
    if  !@previousDirection? then return

    angle = @previousDirection.angleFrom @direction

    if angle * @speed > @traction then @isCrashing = true

  driveInDirection: (direction) ->
    @previousDirection = @direction
    @direction = direction
    @update()

  crash: ->
    @decelerate()
    @update()

    if @speed is 0 then @isCrashing = false

  decelerate: ->
    if @isCrashing
      @speed -= @offRoadDeceleration
      if @speed < 0 then @speed = 0
    else
      @_super()

