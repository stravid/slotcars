  
#= require slotcars/shared/controllers/base_game_controller
#= require slotcars/play/mixins/countdownable

Play.GameController = Shared.BaseGameController.extend Play.Countdownable,

  isRaceFinished: false
  isLastRunNewHighscore: false

  startTime: null
  endTime: null
  raceTime: null
  highscores: null

  lapTimes: null

  init: ->
    @_super()
    @set 'lapTimes', []

  start: ->
    @_super()
    @restartGame()

  finish: ->
    @_setCurrentTime()
    @onLapChange()

    @set 'isRaceFinished', true
    @set 'isRaceRunning', false
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

    run.save => @loadHighscores => @saveGhost()

  loadHighscores: (callback) ->
    @track.loadHighscores (highscores) =>
      @onHighscoresLoaded highscores

      callback() if callback?

  saveGhost: ->
    @checkForNewHighscore()
    return unless @get 'isLastRunNewHighscore'

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

    if time is @raceTime
      @set 'isLastRunNewHighscore', true
    else
      @set 'isLastRunNewHighscore', false

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
    @set 'isRaceRunning', false
    @set 'isRaceFinished', false
    @set 'raceTime', 0
    @set 'lapTimes', []

    @car.reset()
    @startCountdown => @startRace()

  startRace: ->
    @set 'isRaceRunning', true
    @startTime = new Date().getTime()

  _setCurrentTime: ->
    @endTime = new Date().getTime()
    if @get 'isRaceRunning'
      @set 'raceTime', @endTime - @startTime

  destroy: ->
    @_super()
    @set 'isRaceRunning', false