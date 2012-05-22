  
#= require slotcars/shared/controllers/base_game_controller

Play.GameController = Shared.BaseGameController.extend
  
  isCountdownVisible: false
  isRaceFinished: false
  currentCountdownValue: null

  startTime: null
  endTime: null
  raceTime: null
  highscores: null

  timeouts: []
  lapTimes: []

  start: ->
    @_super()
    @restartGame()

  finish: ->
    @_setCurrentTime()
    @onLapChange()

    @set 'isRaceFinished', true
    @set 'carControlsEnabled', false
    @isTouchMouseDown = false

    if Shared.User.current?
      @saveRaceTime()
    else
      @loadHighscores()

  saveRaceTime: ->
    run = Shared.Run.createRecord
      track: @track
      time: @raceTime
      user: Shared.User.current

    run.save => @loadHighscores => @checkForNewHighscore()

  loadHighscores: (callback) ->
    @track.loadHighscores (highscores) =>
      @onHighscoresLoaded highscores

      callback() if callback?

  saveGhost: ->
    ghost = Shared.Ghost.createRecord
      positions: @recordedPositions
      track: @track
      user: Shared.User.current
      time: @raceTime

    ghost.save()

  onHighscoresLoaded: (highscores) ->
    @set 'highscores', Shared.Highscores.create runs: highscores

  checkForNewHighscore: ->
    time = @highscores.getTimeForUserId Shared.User.current.get 'id'

    @saveGhost() if time is @raceTime

  onCarCrossedFinishLine: (->
    car = @get 'car'
    if car.get 'crossedFinishLine' then @finish()
  ).observes 'car.crossedFinishLine'
  
  onLapChange: (->
    # prevent taking time when car enters first lap
    return unless (@car.get 'currentLap') > 1

    sum = (@get 'lapTimes').reduce (previous, current) ->
      previous + current
    , 0

    (@get 'lapTimes').push (@get 'raceTime') - sum

  ).observes 'car.currentLap'

  update: ->
    @_super()
    @_setCurrentTime()

  restartGame: ->
    @set 'carControlsEnabled', false
    @set 'isRaceFinished', false
    @set 'raceTime', 0
    @set 'lapTimes', []

    @car.reset()

    @set 'currentCountdownValue', 3
    @set 'isCountdownVisible', true

    @_clearTimeouts()
    @timeouts[0] = setTimeout (=> @set 'currentCountdownValue', 2 ), 1000
    @timeouts[1] = setTimeout (=> @set 'currentCountdownValue', 1 ), 2000

    @timeouts[2] = setTimeout (=>
      @set 'carControlsEnabled', true
      @startTime = new Date().getTime()
      @set 'currentCountdownValue', 'Go!'
    ), 3000

    @timeouts[3] = setTimeout (=> @set 'isCountdownVisible', false ), 3500

  _clearTimeouts: ->
    for timeout in @timeouts
      clearTimeout timeout

  _setCurrentTime: ->
    @endTime = new Date().getTime()
    if @get 'carControlsEnabled'
      @set 'raceTime', @endTime - @startTime

  destroy: ->
    @_super()
    # clear all timeouts
    @_clearTimeouts()

    # force unbinding of car controls
    @set 'carControlsEnabled', false