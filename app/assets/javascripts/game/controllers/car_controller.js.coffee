
#= require helpers/namespace
#= require vendor/raphael

namespace 'game.controllers'

@game.controllers.CarController = Ember.Object.extend

  speed: 0
  lengthAtTrack: 0
  path: null

  setTrackPath: (path) ->
    @set 'path', path
    @lengthAtTrack = 0
    @_updateCarPosition()

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  slowDown: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0

  drive: ->
    @lengthAtTrack += @speed
    @_updateCarPosition()

    if @lengthAtTrack > @trackLength
      ($ this).trigger 'crossFinishLine'

  updateTrackLength: ( ->
    @trackLength = Raphael.getTotalLength @path
  ).observes 'path'

  _updateCarPosition: ->
    point = Raphael.getPointAtLength @path, @lengthAtTrack

    @mediator.position.set 'x', point.x
    @mediator.position.set 'y', point.y

