describe 'Play.GameController (unit)', ->

  beforeEach ->
    Shared.User.current = null

    @xhr = sinon.useFakeXMLHttpRequest()

    @carMock = mockEmberClass Shared.Car,
      drive: sinon.spy()
      reset: sinon.spy()

    @trackMock = mockEmberClass Shared.Track,
      getPointAtLength: sinon.stub().returns { x: 0, y: 0 }
      getTotalLength: sinon.stub().returns 5
      loadHighscores: sinon.stub()

    @ghostViewMock = mockEmberClass Play.GhostView,
      hide: sinon.stub()

    @gameController = Play.GameController.create
      track: @trackMock
      car: @carMock
      ghostView: @ghostViewMock

  afterEach ->
    @xhr.restore()

    @carMock.restore()
    @trackMock.restore()
    @ghostViewMock.restore()

  describe '#update', ->

    describe 'updating race time', ->

      beforeEach ->
        @fakeTimer = sinon.useFakeTimers()

      afterEach ->
        @fakeTimer.restore()

      it 'should update race time if race is running', ->
        @gameController.set 'isRaceRunning', true

        @gameController.set 'raceTime', 0
        @gameController.set 'startTime', new Date().getTime()

        @fakeTimer.tick 1000
        @gameController.update()

        (expect @gameController.get 'raceTime').toEqual 1000

      it 'should not update race time if race is not running', ->
        @gameController.set 'isRaceRunning', false

        @gameController.set 'raceTime', 0
        @gameController.set 'startTime', new Date().getTime()

        @fakeTimer.tick 1000
        @gameController.update()

        (expect @gameController.get 'raceTime').toEqual 0


  describe '#start', ->

    beforeEach ->
      # base game controller starts the game loop in its #start method
      @gameController.gameLoopController = start: sinon.spy()
      sinon.stub @gameController, 'restartGame'

    it 'should call the restart game function right away if the ghost is set', ->
      @gameController.set 'ghost', {}
      @gameController.start()

      (expect @gameController.restartGame).toHaveBeenCalled()

    it 'should not call the restart game function if the ghost is not set', ->
      @gameController.start()

      (expect @gameController.restartGame).not.toHaveBeenCalled()

    it 'should call the restart game function once the ghost is set', ->
      @gameController.start()

      @gameController.set 'ghost', {}

      (expect @gameController.restartGame).toHaveBeenCalled()

    it 'should call the restart game function if the ghost is not available', ->
      @gameController.start()

      @gameController.set 'isGhostAvailable', false

      (expect @gameController.restartGame).toHaveBeenCalled()

  describe '#finish', ->

    beforeEach ->
      @gameController.isRaceRunning = true
      @gameController.isTouchMouseDown = true
      sinon.spy @gameController, 'saveRaceTime'

    it 'should save timestamp', ->
      @gameController.finish()
      (expect @gameController.endTime).toNotBe null

    it 'should calculate and update race time', ->
      @gameController.finish()
      (expect @gameController.raceTime).toNotBe null

    it 'should set property that race is not running anymore', ->
      @gameController.finish()

      (expect @gameController.isRaceRunning).toBe false

    it 'should stop acceleration', ->
      @gameController.finish()

      (expect @gameController.isTouchMouseDown).toBe false

    it 'should set a flag that race is over', ->
      @gameController.finish()

      (expect @gameController.get 'isRaceFinished').toBe true

    it 'should call saveRaceTime if Shared.User.current is present', ->
      Shared.User.current = {}
      @gameController.finish()

      (expect @gameController.saveRaceTime).toHaveBeenCalled()

    it 'should not call saveRaceTime if Shared.User.current is not present', ->
      Shared.User.current = null
      @gameController.finish()

      (expect @gameController.saveRaceTime).not.toHaveBeenCalled()


  describe 'observing crossed finish line property of car', ->

    beforeEach ->
      @gameController.finish = sinon.spy()

    it 'should observe the crossed finish line property of the car', ->
      (expect @gameController.onCarCrossedFinishLine).toObserve 'car.crossedFinishLine'

    it 'should finish the race when car crossed finish line', ->
      @carMock.set 'crossedFinishLine', true

      (expect @gameController.finish).toHaveBeenCalled()

    it 'should not finish the race when car didnt cross the finish line yet', ->
      @carMock.set 'crossedFinishLine', false

      (expect @gameController.finish).not.toHaveBeenCalled()

  describe '#restartGame', ->

    beforeEach ->
      sinon.stub @gameController, 'startCountdown'
      sinon.stub @gameController, 'startRace'

    it 'should reset raceTime', ->
      @gameController.raceTime = 18
      @gameController.restartGame()

      (expect @gameController.get 'raceTime').toBe 0

    it 'should reset car', ->
      @gameController.restartGame()

      (expect @carMock.reset).toHaveBeenCalled()

    it 'should unset the flag that the race is running', ->
      @gameController.restartGame()

      (expect @gameController.get 'isRaceRunning').toBe false

    it 'should unset the flag wether the race is finished', ->
      @gameController.restartGame()

      (expect @gameController.get 'isRaceFinished').toBe false

    it 'should reset lap times when race is reset', ->
      @gameController.lapTimes.push(123)
      @gameController.restartGame()

      (expect @gameController.lapTimes).toEqual []

    it 'should start countdown and provide start race method as callback', ->
      @gameController.restartGame()

      # anonymous callback calls start race on the right context: => @startRace()
      anonymousCallbackToStartCountdown = @gameController.startCountdown.args[0][0]
      anonymousCallbackToStartCountdown()

      (expect @gameController.startCountdown).toHaveBeenCalled()
      (expect @gameController.startRace).toHaveBeenCalled()


  describe 'starting race', ->

    it 'should flag the race as running after countdown', ->
      @gameController.startRace()

      (expect @gameController.get 'isRaceRunning').toBe true

    it 'should save timestamp after countdown', ->
      @gameController.startRace()

      (expect @gameController.get 'startTime').toBeDefined()


  describe 'saving lap times', ->

    it 'should save lap time when current lap of car changes', ->
      @carMock.set 'currentLap', 2

      (expect @gameController.lapTimes.length).toBe 1

    it 'should save the difference of total minus the previous laps', ->
      @gameController.set 'raceTime', 1000
      @gameController.set 'lapTimes', [200, 300]

      @carMock.set 'currentLap', 3

      (expect @gameController.lapTimes[2]).toBe 500

    it 'should not save lap time before car reaches second lap', ->
      @carMock.set 'currentLap', 1 # car crossed start line - enters first lap
      @gameController.onLapChange()

      (expect @gameController.lapTimes.length).toBe 0


  describe 'destroy', ->

    beforeEach ->
      # base game controller destroys the game loop in its #destroy method
      @gameController.gameLoopController = destroy: sinon.spy()

    it 'should set the flag that race is running to false', ->
      sinon.spy @gameController, 'set'
      @gameController.destroy()

      (expect @gameController.set).toHaveBeenCalledWith 'isRaceRunning', false

  describe 'saveRaceTime', ->

    beforeEach ->
      sinon.spy Shared.Run, 'createRecord'

    afterEach ->
      Shared.Run.createRecord.restore()

    it 'should create a new Run record', ->
      time = 100
      @gameController.set 'raceTime', time
      @gameController.saveRaceTime()

      (expect Shared.Run.createRecord).toHaveBeenCalledWithAnObjectLike
        track: @trackMock
        time: time
        user: Shared.User.current

  describe '#isNewHighscore', ->

    beforeEach ->
      @highscoreTime = 9
      @highscoresMock = mockEmberClass Shared.Highscores,
        getTimeForUserId: sinon.stub().returns @highscoreTime

      Shared.User.current =
        get: ->

      @gameController.onHighscoresLoaded()

    afterEach ->
      @highscoresMock.restore()

      Shared.User.current = null

    it 'should return true if the highscore is better', ->
      @gameController.raceTime = @highscoreTime
      (expect @gameController.isNewHighscore()).toBe true

    it 'should return false if the highscore did not improve', ->
      @gameController.raceTime = 10
      (expect @gameController.isNewHighscore()).toBe false

  describe '#saveGhost', ->

    beforeEach ->
      sinon.spy Shared.Ghost, 'createRecord'

    afterEach ->
      Shared.Ghost.createRecord.restore()

    it 'should create a new Ghost record if it is a new highscore', ->
      time = 100
      recordedPositions = [{ x: 1 }, { x: 2 }]
      @gameController.set 'raceTime', time
      @gameController.set 'recordedPositions', recordedPositions

      @gameController.isNewHighscore = sinon.stub().returns true

      @gameController.saveGhost()

      (expect Shared.Ghost.createRecord).toHaveBeenCalledWithAnObjectLike
        track: @trackMock
        time: time
        user: Shared.User.current
        positions: recordedPositions

    it 'should not create a new Ghost if it is not a new highscore', ->
      @gameController.isNewHighscore = sinon.stub().returns false

      (expect Shared.Ghost.createRecord).not.toHaveBeenCalled()
