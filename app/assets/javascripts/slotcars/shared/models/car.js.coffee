
#= require helpers/namespace
#= require helpers/math/vector

#= require slotcars/shared/lib/movable
#= require slotcars/shared/lib/crashable

namespace 'slotcars.shared.models'

Movable = slotcars.shared.lib.Movable
Crashable = slotcars.shared.lib.Crashable

slotcars.shared.models.Car = Ember.Object.extend Movable, Crashable,

  speed: 0
  maxSpeed: 0
  traction: 0

  acceleration: 0
  deceleration: 0
  crashDeceleration: 0

  track: null
  lengthAtTrack: 0

  currentLap: 0
  crossedFinishLine: false

  _onLengthAtTrackChanged: (->
    track = @get 'track'
    if track?
      lapForLengthAtTrack = (track.lapForLength @get 'lengthAtTrack')
      if lapForLengthAtTrack isnt @get 'currentLap' then @set 'currentLap', lapForLengthAtTrack

      isLengthAfterFinishLine = (track.isLengthAfterFinishLine @get 'lengthAtTrack')
      if isLengthAfterFinishLine isnt @get 'crossedFinishLine' then @set 'crossedFinishLine', isLengthAfterFinishLine
  ).observes 'lengthAtTrack'

  drive: ->
    newLength = (@get 'lengthAtTrack') + (@get 'speed')
    @set 'lengthAtTrack', newLength

  jumpstart: ->
    @speed = @deceleration + .0001 unless @speed > 0

  accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  decelerate: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0

  crashcelerate: ->
    @speed -= @crashDeceleration
    if @speed < 0 then @speed = 0

  reset: ->
    @speed = 0
    @set 'lengthAtTrack', 0
