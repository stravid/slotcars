
#= require helpers/math/vector

#= require slotcars/shared/lib/movable
#= require slotcars/shared/lib/crashable

Movable = slotcars.shared.lib.Movable
Crashable = slotcars.shared.lib.Crashable

(namespace 'slotcars.shared.models').Car = Ember.Object.extend Movable, Crashable,

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

  init: ->
    throw 'No track specified' unless @track?

  update: (isTouchMouseDown) ->
    unless @isCrashing
      if isTouchMouseDown
        @accelerate()
      else
        @decelerate()

      newLengthAtTrack = (@get 'lengthAtTrack') + (@get 'speed')
      nextPosition = @track.getPointAtLength newLengthAtTrack

      @checkForCrash nextPosition # isCrashing can be modified inside

    if @isCrashing
      @crashcelerate()
      @crash()
    else
      @drive()      # automatically handles 'respawn'

      previousPosition = @track.getPointAtLength newLengthAtTrack - 0.1
      @moveTo { x: nextPosition.x, y: nextPosition.y }, { x: previousPosition.x , y: previousPosition.y }

  drive: ->
    newLength = (@get 'lengthAtTrack') + (@get 'speed')
    @set 'lengthAtTrack', newLength

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

    position = @track.getPointAtLength 0
    @moveTo { x: position.x, y: position.y }
