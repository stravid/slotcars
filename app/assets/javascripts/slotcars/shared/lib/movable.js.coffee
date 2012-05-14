Shared.Movable = Ember.Mixin.create

  lengthAtTrack: 0
  nextLengthAtTrack: 0

  position: null
  nextPosition: null

  rotation: 0
  nextRotation: 0

  init: ->
    @_super()
    throw 'No track specified' unless @track?

  moveToStartPosition: ->
    @set 'speed', 0
    @set 'lengthAtTrack', 0
    @set 'nextLengthAtTrack', 0

    @moveToNextPosition()

  moveAlongTrack: ->
    @set 'nextLengthAtTrack', @lengthAtTrack + @speed
    @moveToNextPosition()

  calculateNextPosition: -> @set 'nextPosition', @track.getPointAtLength @nextLengthAtTrack

  calculateNextRotation: ->
    previousLengthAtTrack = @lengthAtTrack - 0.1
    previousPosition = @track.getPointAtLength previousLengthAtTrack

    directionToNextPosition = Shared.Vector.create from: previousPosition, to: @nextPosition
    @set 'nextRotation', directionToNextPosition.clockwiseAngle()

  moveToNextPosition: ->
    @calculateNextPosition()
    @calculateNextRotation()

    @set 'lengthAtTrack', @nextLengthAtTrack
    @set 'position', @nextPosition
    @set 'rotation', @nextRotation