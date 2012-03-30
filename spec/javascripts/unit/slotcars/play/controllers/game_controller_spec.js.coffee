
#= require slotcars/play/controllers/game_controller
#= require slotcars/play/controllers/game_loop_controller

#= require slotcars/shared/models/track
#= require slotcars/shared/models/car

describe 'slotcars.play.controllers.GameController (unit)', ->

  GameController = slotcars.play.controllers.GameController
  GameLoopController = slotcars.play.controllers.GameLoopController
  Track = slotcars.shared.models.Track
  Car = slotcars.shared.models.Car

  beforeEach ->
    @carMock = mockEmberClass Car,
      update: sinon.spy()
      reset: sinon.spy()

    @trackMock = mockEmberClass Track,
      getPointAtLength: sinon.stub().returns { x: 0, y: 0 }
      getTotalLength: sinon.stub().returns 5

    @gameController = GameController.create
      track: @trackMock
      car: @carMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()

  it 'should extend Ember.Object', ->
    (expect GameController).toExtend Ember.Object

  it 'should set isTouchMouseDown to false by default', ->
    (expect @gameController.isTouchMouseDown).toBe false

  it 'should set carControlsEnabled to false by default', ->
    (expect @gameController.carControlsEnabled).toBe false

  it 'should throw an error when no track is provided', ->
    (expect => GameController.create car: Car.create()).toThrow()

  it 'should throw an error when no car is provided', ->
    (expect => GameController.create track: @trackMock).toThrow()

  it 'should create a game loop controller', ->
    @GameLoopControllerMock = mockEmberClass GameLoopController
    GameController.create
      track: @trackMock
      car: Car.create()

    (expect @GameLoopControllerMock.create).toHaveBeenCalledOnce()
    
    @GameLoopControllerMock.restore()

  describe '#onTouchMouseDown', ->

    it 'should set isTouchMouseDown to true', ->
      eventStub = originalEvent: preventDefault: ->

      @gameController.onTouchMouseDown eventStub

      (expect @gameController.isTouchMouseDown).toBe true

  describe '#onTouchMouseUp', ->

    it 'should set isTouchMouseDown to false', ->
      eventStub = originalEvent:
        preventDefault: ->

      @gameController.onTouchMouseUp eventStub

      (expect @gameController.isTouchMouseDown).toBe false

  describe '#update', ->

    it 'should call the update function of the car', ->
      @gameController.update()

      (expect @carMock.update).toHaveBeenCalledWith @gameController.isTouchMouseDown

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

    beforeEach ->
      @trackStub = Track.createRecord()
      @trackStub.addPathPoint { x: 10, y: 10 }
      @trackStub.addPathPoint { x: 20, y: 50 }
      @trackStub.addPathPoint { x: 30, y: 40 }

      @gameLoopControllerMock = mockEmberClass GameLoopController,
        start: (renderCallback) ->
          renderCallback()

      @gameController.track = @trackStub
      @gameController.update = sinon.spy()
      sinon.spy @gameController, 'restartGame'

    afterEach ->
      @gameLoopControllerMock.restore()

    it 'should start the game loop with #update method as renderCallback', ->
      @gameController.gameLoopController = @gameLoopControllerMock
      @gameController.start()

      (expect @gameController.update).toHaveBeenCalled()

    it 'should call the restart game function', ->
      @gameController.start()

      (expect @gameController.restartGame).toHaveBeenCalled()

  describe '#finish', ->

    beforeEach ->
      @gameController.carControlsEnabled = true
      @gameController.isTouchMouseDown = true

    it 'should save timestamp', ->
      @gameController.finish()
      (expect @gameController.endTime).toNotBe null

    it 'should calculate and update race time', ->
      @gameController.finish()
      (expect @gameController.raceTime).toNotBe null

    it 'should disable car controls', ->
      @gameController.finish()

      (expect @gameController.carControlsEnabled).toBe false

    it 'should disable stop acceleration', ->
      @gameController.finish()

      (expect @gameController.isTouchMouseDown).toBe false
      
    it 'should set a flag when race is over', ->
      @gameController.finish()
      
      (expect @gameController.get 'isRaceFinished').toBe true

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
    
    it 'should save lap time when current lap of car changes', ->
      @gameController.lapTimes = []
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

      (expect @gameController.lapTimes[1]).toBe 3000
      
      fakeTimer.restore()

    it 'should not save lap time if lap time is zero', ->
      # this test sounds weird but it´s neccessary to check
      fakeTimer = sinon.useFakeTimers()
      @gameController.restartGame()

      @gameController._setCurrentTime() # normaly caused by game loop
      @gameController.onLapChange()
      
      (expect @gameController.lapTimes.length).toBe 0

      fakeTimer.restore()

  describe 'destroy', ->

    it 'should call destroy of the game loop controller', ->
      gameLoopControllerStub =
        destroy: sinon.spy()

      @gameController.set 'gameLoopController', gameLoopControllerStub
      @gameController.destroy()

      (expect gameLoopControllerStub.destroy).toHaveBeenCalled()
