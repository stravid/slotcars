Shared.Movable = Ember.Mixin.create

  lengthAtTrack: 0
  position: null
  rotation: 0

  init: ->
    @_super()
    throw 'No track specified' unless @track?

  moveToStartPosition: ->
    @set 'speed', 0
    @set 'lengthAtTrack', 0

    @moveAlongTrack()

  moveAlongTrack: ->
    @set 'rotation', @getNextRotation()
    @set 'position', @getNextPosition()
    @set 'lengthAtTrack', @getNextLengthAtTrack()

  getNextLengthAtTrack: -> @lengthAtTrack + @speed

  getNextPosition: -> @track.getPointAtLength @getNextLengthAtTrack()

  getNextRotation: ->
    previousLengthAtTrack = @lengthAtTrack - 0.1
    previousPosition = @track.getPointAtLength previousLengthAtTrack

    directionToNextPosition = Shared.Vector.create from: previousPosition, to: @getNextPosition()
    directionToNextPosition.clockwiseAngle()