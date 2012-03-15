
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
    @trackMock = mockEmberClass Track,
      getPointAtLength: sinon.stub().returns { x: 0, y: 0 }
      getTotalLength: sinon.stub().returns 5

    @gameController = GameController.create
      track: @trackMock
      car: Car.create()

  afterEach ->
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

  it 'should provide the current track for the car', ->
    (expect @gameController.car.track).toBe @trackMock

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

    beforeEach ->
      @carMock = mockEmberClass Car,
        accelerate: sinon.spy()
        decelerate: sinon.spy()
        crashcelerate: sinon.spy()
        moveTo: sinon.spy()
        checkForCrash: sinon.spy()
        drive: sinon.spy()
        jumpstart: sinon.spy()
        crash: sinon.spy()
        reset: sinon.spy()
        get: sinon.stub().returns 0

      @GameLoopControllerMock = mockEmberClass GameLoopController,
        start: sinon.spy()

      @gameController.set 'car', @carMock

    afterEach ->
      @GameLoopControllerMock.restore()
      @carMock.restore()

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

    describe 'when car is on track', ->

      beforeEach ->
        @gameController.car.isCrashing = false

      it 'should accelerate car when isTouchMouseDown is true', ->
        @gameController.isTouchMouseDown = true
        @gameController.update()

        (expect @carMock.accelerate).toHaveBeenCalledOnce()

      it 'should slow down when isTouchMouseDown is false', ->
        @gameController.isTouchMouseDown = false
        @gameController.update()

        (expect @carMock.decelerate).toHaveBeenCalledOnce()
        (expect @carMock.accelerate).not.toHaveBeenCalled()

      it 'should move car', ->
        @gameController.update()

        (expect @carMock.drive).toHaveBeenCalledOnce()
        (expect @carMock.jumpstart).toHaveBeenCalledOnce()
        (expect @carMock.moveTo).toHaveBeenCalledOnce()

      it 'should check for crash', ->
        @gameController.update()

        (expect @carMock.checkForCrash).toHaveBeenCalledOnce()

    describe 'when car is crashing', ->
  
      beforeEach ->
        @gameController.update() # simulates normal driving mode
        @gameController.car.isCrashing = true

      it 'should slow down', ->
        @gameController.update()

        (expect @carMock.crashcelerate).toHaveBeenCalledOnce()

      it 'should not be possible to accelerate the car', ->
        @gameController.isTouchMouseDown = true
        @gameController.update()

        (expect @carMock.accelerate).not.toHaveBeenCalled()

      it 'should update the car´s position', ->
        @gameController.update()

        (expect @carMock.crash).toHaveBeenCalledOnce()

  describe '#start', ->

    beforeEach ->
      @trackStub = Track.createRecord()
      @trackStub.addPathPoint { x: 10, y: 10 }
      @trackStub.addPathPoint { x: 20, y: 50 }

      @gameLoopControllerMock = mockEmberClass GameLoopController,
        start: (renderCallback) ->
          renderCallback()

      @gameController.track = @trackStub
      @gameController.update = sinon.spy()

    afterEach ->
      @gameLoopControllerMock.restore()

    it 'should start the game loop with #update method as renderCallback', ->
      @gameController.gameLoopController = @gameLoopControllerMock
      @gameController.start()

      (expect @gameController.update).toHaveBeenCalled()

    it 'should set car to startposition', ->
      @gameController.start()
      (expect @gameController.car.get 'position').toEqual { x: 10, y: 10 }

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

  describe 'observing crossed finish line property of car', ->

    beforeEach ->
      @carMock = mockEmberClass Car
      @gameController.finish = sinon.spy()

    afterEach ->
      @carMock.restore()

    it 'should observe the crossed finish line property of the car', ->
      (expect @gameController.onCarCrossedFinishLine).toObserve 'car.crossedFinishLine'

    it 'should finish the race when car crossed finish line', ->
      @carMock.get = sinon.stub().withArgs('crossedFinishLine').returns true
      @gameController.set 'car', @carMock

      (expect @gameController.finish).toHaveBeenCalled()

    it 'should not finish the race when car didnt cross the finish line yet', ->
      @carMock.get = sinon.stub().withArgs('crossedFinishLine').returns false
      @gameController.set 'car', @carMock

      (expect @gameController.finish).not.toHaveBeenCalled()

  describe '#restartGame', ->

    beforeEach ->
      @carMock = mockEmberClass Car,
        reset: sinon.spy()
        moveTo: sinon.spy()
        jumpstart: sinon.spy()
        get: sinon.spy()

    afterEach ->
      @carMock.restore()

    it 'should reset raceTime', ->
      @gameController.raceTime = 18
      @gameController.restartGame()

      (expect @gameController.get 'raceTime').toBe 0

    it 'should reset car', ->
      @gameController.set 'car', @carMock
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
