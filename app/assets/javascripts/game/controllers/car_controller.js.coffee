
#= require helpers/namespace
#= require vendor/raphael

namespace 'game.controllers'

@game.controllers.CarController = Ember.Object.extend

  speed: 0
  lengthAtTrack: 0

  setTrackPath: (path) ->
    @lengthAtTrack = 0
    point = Raphael.getPointAtLength(path, 0)
    @mediator.position.set 'x', point.x
    @mediator.position.set 'y', point.y

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  slowDown: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0
