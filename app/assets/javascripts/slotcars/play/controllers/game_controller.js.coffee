
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

  init: ->
    @_super()
    @set 'lapTimes', []

    @initializeGhostForCurrentUserHighscore() if Shared.User.current?

  initializeGhostForCurrentUserHighscore: ->
    highscoreOnTrack = Shared.User.current.getTimeForTrackId @track.get 'id'

    @loadGhost highscoreOnTrack if highscoreOnTrack?

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
      @loadGhost @raceTime if @isGhostDefeated()

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
      error: -> # no ghost for this track

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

    ghost.on 'didCreate', => @loadGhost @raceTime
    ghost.save()

  onHighscoresLoaded: (highscores) ->
    @set 'highscores', Shared.Highscores.create runs: highscores

    if @isNewHighscore()
      @saveGhost()
    else
      @loadGhost @raceTime if @isGhostDefeated()

  isNewHighscore: ->
    time = @highscores.getTimeForUserId Shared.User.current.get 'id'

    time is @raceTime

  isGhostDefeated: ->
    @raceTime < @ghost?.get 'time'

  initializeGhost: (ghost) ->
    Shared.ModelStore.load Shared.Ghost, ghost

    @ghost = Shared.Ghost.find ghost.id

    @ghost.fire 'didLoad'

    @ghostView.set 'car', @car
    @ghostView.set 'ghost', @ghost
    @ghostView.show()

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
