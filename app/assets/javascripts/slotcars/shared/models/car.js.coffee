
#= require slotcars/shared/mixins/movable
#= require slotcars/shared/mixins/crashable
#= require slotcars/shared/mixins/drivable

Shared.Car = Ember.Object.extend Shared.Movable, Shared.Drivable, Shared.Crashable,

  track: null

  # default configuration
  acceleration: 0.1
  deceleration: 0.2
  crashDeceleration: 0.4
  maxSpeed: 15
  traction: 38

  currentLap: 0
  crossedFinishLine: false

  drive: (shouldAccelerate) ->
    @checkForCrash() unless @isCrashing

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