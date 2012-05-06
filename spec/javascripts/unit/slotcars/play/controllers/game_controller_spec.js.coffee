describe 'Play.GameController (unit)', ->

  beforeEach ->
    @xhr = sinon.useFakeXMLHttpRequest()

    @carMock = mockEmberClass Shared.Car,
      update: sinon.spy()
      reset: sinon.spy()

    @trackMock = mockEmberClass Shared.Track,
      getPointAtLength: sinon.stub().returns { x: 0, y: 0 }
      getTotalLength: sinon.stub().returns 5
      loadHighscores: sinon.stub()

    @gameController = Play.GameController.create
      track: @trackMock
      car: @carMock

  afterEach ->
    @xhr.restore()

    @carMock.restore()
    @trackMock.restore()

  describe '#update', ->

    describe 'updating race time', ->

      beforeEach ->
        @fakeTimer = sinon.useFakeTimers()

      afterEach ->
        @fakeTimer.restore()

      it 'should update race time as long car is allowed to drive', ->
        @gameController.set 'carControlsEnabled', true

        @gameController.set 'raceTime', 0
        @gameController.set 'startTime', new Date().getTime()

        @fakeTimer.tick 1000
        @gameController.update()

        (expect @gameController.get 'raceTime').toEqual 1000

      it 'should not update race time when car isn´t allowed to drive', ->
        @gameController.set 'carControlsEnabled', false

        @gameController.set 'raceTime', 0
        @gameController.set 'startTime', new Date().getTime()

        @fakeTimer.tick 1000
        @gameController.update()

        (expect @gameController.get 'raceTime').toEqual 0


  describe '#start', ->

    it 'should call the restart game function', ->
      sinon.spy @gameController, 'restartGame'
      @gameController.start()

      (expect @gameController.restartGame).toHaveBeenCalled()

  describe '#finish', ->

    beforeEach ->
      @gameController.carControlsEnabled = true
      @gameController.isTouchMouseDown = true
      sinon.spy @gameController, 'saveRaceTime'

    it 'should save timestamp', ->
      @gameController.finish()
      (expect @gameController.endTime).toNotBe null

    it 'should calculate and update race time', ->
      @gameController.finish()
      (expect @gameController.raceTime).toNotBe null

    it 'should disable car controls', ->
      @gameController.finish()

      (expect @gameController.carControlsEnabled).toBe false

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

    it 'should reset raceTime', ->
      @gameController.raceTime = 18
      @gameController.restartGame()

      (expect @gameController.get 'raceTime').toBe 0

    it 'should reset car', ->
      @gameController.restartGame()

      (expect @carMock.reset).toHaveBeenCalled()

    it 'should clear timeouts', ->
      clearTimeoutBackup = clearTimeout
      window.clearTimeout = sinon.spy()
      @gameController.restartGame()

      (expect window.clearTimeout).toHaveBeenCalled()
      window.clearTimeout = clearTimeoutBackup

    it 'should disable car controls', ->
      @gameController.restartGame()

      (expect @gameController.get 'carControlsEnabled').toBe false

    it 'should set flag to show countdown', ->
      @gameController.restartGame()
      
      (expect @gameController.get 'isCountdownVisible').toBe true
      
    it 'should unset the flag wether the race is finished', ->
      @gameController.restartGame()
      
      (expect @gameController.get 'isRaceFinished').toBe false
      
    it 'should reset lap times when race is reset', ->
      @gameController.lapTimes.push(123)
      @gameController.restartGame()
       
      (expect @gameController.lapTimes).toEqual []
  
    describe 'after countdown', ->

      beforeEach ->
        @fakeTimer = sinon.useFakeTimers()

      afterEach ->
        @fakeTimer.restore()

      it 'should enable controls after countdown', ->
        @gameController.restartGame()

        @fakeTimer.tick 3000
        (expect @gameController.get 'carControlsEnabled').toBe true

      it 'should save timestamp after countdown', ->
        @gameController.restartGame()

        @fakeTimer.tick 3000

        (expect @gameController.get 'startTime').toNotBe null

      it 'should set flag to hide countdown', ->
        @gameController.restartGame()
        @fakeTimer.tick 3500

        (expect @gameController.get 'isCountdownVisible').toBe false

  describe 'saving lap times', ->

    beforeEach ->
      @carMock.set 'currentLap', 2 # car finished first lap -> enters second lap
      @gameController.lapTimes = []

    it 'should save lap time when current lap of car changes', ->
      @gameController.onLapChange()

      (expect @gameController.lapTimes.length).toBe 1
      
    it 'should save the difference of total minus first lap', ->
      fakeTimer = sinon.useFakeTimers()
      @gameController.restartGame()
      
      fakeTimer.tick 5000 # 3 seconds count down - 2 seconds lap
      @gameController._setCurrentTime() # normaly caused by game loop
      @gameController.onLapChange()
      
      fakeTimer.tick 3000
      @gameController._setCurrentTime() # normaly caused by game loop
      @gameController.onLapChange()

      (expect @gameController.lapTimes[0]).toBe 2000
      (expect @gameController.lapTimes[1]).toBe 3000

      fakeTimer.restore()

    it 'should not save lap time before car reaches second lap', ->
      @carMock.set 'currentLap', 1 # car crossed start line - enters first lap
      @gameController.onLapChange()

      (expect @gameController.lapTimes.length).toBe 0


  describe 'destroy', ->

    it 'should disable car controls', ->
      sinon.spy @gameController, 'set'
      @gameController.destroy()

      (expect @gameController.set).toHaveBeenCalledWith 'carControlsEnabled', false

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
