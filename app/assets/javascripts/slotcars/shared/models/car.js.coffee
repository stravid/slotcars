
#= require slotcars/shared/lib/movable
#= require slotcars/shared/lib/crashable

Shared.Car = Ember.Object.extend Shared.Movable, Shared.Drivable, Shared.Crashable,

  track: null

  # default configuration
  acceleration: 0.1
  deceleration: 0.2
  crashDeceleration: 0.3
  maxSpeed: 18
  traction: 45

  currentLap: 0
  crossedFinishLine: false

  drive: (shouldAccelerate) ->
    if @isCrashing
      @moveCarInCrashingDirection()
    else
      @accelerate shouldAccelerate
      @moveAlongTrack()

  _onLengthAtTrackChanged: (->
    track = @get 'track'
    if track?
      lapForLengthAtTrack = (track.lapForLength @get 'lengthAtTrack')
      if lapForLengthAtTrack isnt @get 'currentLap' then @set 'currentLap', lapForLengthAtTrack

      isLengthAfterFinishLine = (track.isLengthAfterFinishLine @get 'lengthAtTrack')
      if isLengthAfterFinishLine isnt @get 'crossedFinishLine' then @set 'crossedFinishLine', isLengthAfterFinishLine
  ).observes 'lengthAtTrack'

  reset: -> @moveToStartPosition()