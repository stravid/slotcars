
#= require helpers/math/vector

#= require slotcars/shared/lib/movable
#= require slotcars/shared/lib/crashable

Shared.Car = Ember.Object.extend Shared.Movable, Shared.Crashable,

  speed: 0
  maxSpeed: 0
  traction: 0

  acceleration: 0
  deceleration: 0
  crashDeceleration: 0

  track: null
  lengthAtTrack: null

  currentLap: 0
  crossedFinishLine: false

  init: ->
    throw 'No track specified' unless @track?

  update: (isTouchMouseDown) ->

    nextLengthAtTrack = (@get 'lengthAtTrack') + (@get 'speed')
    nextPosition = @track.getPointAtLength nextLengthAtTrack

    unless @isCrashing
      if isTouchMouseDown
        @_accelerate()
      else
        @_decelerate()

      @checkForCrash nextPosition # isCrashing can be modified inside

    if @isCrashing
      @_crashcelerate()
      @crash()
    else
      @_drive() # automatically handles 'respawn'

      previousPosition = @track.getPointAtLength nextLengthAtTrack - 0.1
      @moveTo { x: nextPosition.x, y: nextPosition.y }, { x: previousPosition.x , y: previousPosition.y }

  reset: ->
    @speed = 0
    @set 'lengthAtTrack', 0

    position = @track.getPointAtLength 0
    @moveTo { x: position.x, y: position.y }

  _onLengthAtTrackChanged: (->
    track = @get 'track'
    if track?
      lapForLengthAtTrack = (track.lapForLength @get 'lengthAtTrack')
      if lapForLengthAtTrack isnt @get 'currentLap' then @set 'currentLap', lapForLengthAtTrack

      isLengthAfterFinishLine = (track.isLengthAfterFinishLine @get 'lengthAtTrack')
      if isLengthAfterFinishLine isnt @get 'crossedFinishLine' then @set 'crossedFinishLine', isLengthAfterFinishLine
  ).observes 'lengthAtTrack'

  _drive: ->
    newLength = (@get 'lengthAtTrack') + (@get 'speed')
    @set 'lengthAtTrack', newLength

  _accelerate: ->
    @speed += @acceleration
    if @speed > @maxSpeed then @speed = @maxSpeed

  _decelerate: ->
    @speed -= @deceleration
    if @speed < 0 then @speed = 0

  _crashcelerate: ->
    @speed -= @crashDeceleration
    if @speed < 0 then @speed = 0
