
#= require slotcars/shared/controllers/base_game_controller
#= require slotcars/play/mixins/countdownable

Play.GameController = Shared.BaseGameController.extend Play.Countdownable,

  isRaceFinished: false

  startTime: null
  endTime: null
  raceTime: null
  highscores: null

  lapTimes: null

  ghost: null
  personalBestRaceTime: 999999999
  isGhostAvailable: null

  init: ->
    @_super()
    @set 'lapTimes', []

    @getPersonalBestRaceTimeOfCurrentUser() if Shared.User.current?
    @loadGhost @personalBestRaceTime

  getPersonalBestRaceTimeOfCurrentUser: ->
    highscoreOnTrack = Shared.User.current.getTimeForTrackId @track.get 'id'

    @personalBestRaceTime = highscoreOnTrack if highscoreOnTrack?

  start: ->
    @_super()

    if @ghost?
      @restartGame()
    else
      @addObserver 'ghost', this, 'onFirstGhostLoaded'
      @addObserver 'isGhostAvailable', this, 'onFirstGhostLoaded'

  onFirstGhostLoaded: ->
    @removeObserver 'ghost', this, 'onFirstGhostLoaded'
    @removeObserver 'isGhostAvailable', this, 'onFirstGhostLoaded'

    @restartGame()

  finish: ->
    @_setCurrentTime()
    @onLapChange()

    @set 'isRaceFinished', true
    @set 'isRaceRunning', false
    @isTouchMouseDown = false

    @ghostView.hide()

    @personalBestRaceTime = @raceTime if @raceTime < @personalBestRaceTime

    if Shared.User.current?
      @saveRaceTime()
    else
      @loadHighscores()
      @loadGhost @personalBestRaceTime

  saveRaceTime: ->
    run = Shared.Run.createRecord
      track: @track
      time: @raceTime
      user: Shared.User.current

    run.save => @loadHighscores()

  loadHighscores: ->
    @track.loadHighscores (highscores) =>
      @onHighscoresLoaded highscores

  loadGhost: (time) ->
    jQuery.ajax "/api/ghosts",
      type: "GET"
      dataType: 'json'
      data:
        track_id: @track.get 'id'
        time: time
      success: (response) => @initializeGhost response.ghost
      error: => @set 'isGhostAvailable', false

  saveGhost: ->
    if @isRecording
      @addObserver 'isRecording', this, 'onIsRecordingChange'
    else
      @createGhost()

  onIsRecordingChange: ->
    @removeObserver 'isRecording', this, 'onIsRecordingChange'

    @createGhost()

  createGhost: ->
    ghost = Shared.Ghost.createRecord
      positions: @recordedPositions
      track: @track
      user: Shared.User.current
      time: @raceTime

    ghost.on 'didCreate', => @loadGhost @personalBestRaceTime
    ghost.save()

  onHighscoresLoaded: (highscores) ->
    @set 'highscores', Shared.Highscores.create runs: highscores

    return unless Shared.User.current?

    if @isNewHighscore()
      @saveGhost()
    else
      @loadGhost @personalBestRaceTime

  isNewHighscore: ->
    time = @highscores.getTimeForUserId Shared.User.current.get 'id'

    time is @raceTime

  initializeGhost: (ghost) ->
    Shared.ModelStore.load Shared.Ghost, ghost

    ghost = Shared.Ghost.find ghost.id
    ghost.fire 'didLoad'

    @ghostView.set 'car', @car
    @ghostView.set 'ghost', ghost

    @set 'ghost', ghost

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

    @ghost.drive @raceTime if @ghost?

  restartGame: ->
    @set 'isRaceRunning', false
    @set 'isRaceFinished', false
    @set 'raceTime', 0
    @set 'lapTimes', []

    @car.reset()
    @ghost.reset() if @ghost?
    @ghostView.show() if @ghost?

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
