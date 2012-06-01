Shared.Ghost = DS.Model.extend

  positions: DS.attr 'json'
  time: DS.attr 'number'
  user: DS.belongsTo 'Shared.User'
  track: DS.belongsTo 'Shared.Track'

  currentPositionIndex: 0
  position: null
  rotation: null

  didLoad: -> @reset()

  reset: ->
    @currentPositionIndex = 0
    @rotation = (@get 'positions')[0].rotation
    @set 'position',
      x: (@get 'positions')[0].x
      y: (@get 'positions')[0].y

  save: -> Shared.ModelStore.commit()

  drive: (millisecondsSinceStart) ->
    positions = @get 'positions'

    if millisecondsSinceStart >= positions[@currentPositionIndex].time
      position =
        x: positions[@currentPositionIndex].x
        y: positions[@currentPositionIndex].y

      @set 'position', position
      @set 'rotation', positions[@currentPositionIndex].rotation

      @currentPositionIndex++ while positions[@currentPositionIndex].time < millisecondsSinceStart and @currentPositionIndex < positions.length - 1

  belongsToCurrentUser: (->
    Shared.User.current is @get 'user'
  ).property 'user', 'Shared.User.current'