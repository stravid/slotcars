
#= require slotcars/play/controllers/game_controller
#= require slotcars/play/controllers/game_loop_controller

#= require slotcars/shared/models/track_model
#= require slotcars/shared/models/car

describe 'slotcars.play.controllers.GameController (unit)', ->

  GameController = slotcars.play.controllers.GameController
  GameLoopController = slotcars.play.controllers.GameLoopController
  TrackModel = slotcars.shared.models.TrackModel
  Car = slotcars.shared.models.Car

  beforeEach ->
    @trackMock = mockEmberClass TrackModel,
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

      @gameController.car = @carMock

    afterEach ->
      @GameLoopControllerMock.restore()
      @carMock.restore()

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

      it 'should trigger event when crossing finish line', ->
        @carMock.get = sinon.stub().returns 30  # trackMock returns length of 5
        @gameController.finish = sinon.spy()

        # bind event inside #restartGame (or in #start - but #start also starts the game loop)      
        @gameController.restartGame()
        @gameController.update()

        (expect @gameController.finish).toHaveBeenCalledOnce()

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
      @trackStub = TrackModel.createRecord()
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

  describe '#restartGame', ->

    beforeEach ->
      @carMock = mockEmberClass Car,
        reset: sinon.spy()
        moveTo: sinon.spy()
        jumpstart: sinon.spy()

    afterEach ->
      @carMock.restore()

    it 'should reset raceTime', ->
      @gameController.raceTime = 18
      @gameController.restartGame()

      (expect @gameController.get 'raceTime').toBe 0

    it 'should reset car', ->
      @gameController.car = @carMock
      @gameController.restartGame()

      (expect @carMock.reset).toHaveBeenCalled()

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
