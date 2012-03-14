
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

    it 'should be called when isTouchMouseDown is triggered on document', ->

      # necessary to trigger 'mousedown' because of 'originalEvent'
      # property which is added through event normalization
      (jQuery document).trigger 'mousedown'

      (expect @gameController.isTouchMouseDown).toBe true

  describe '#onTouchMouseUp', ->

    it 'should set isTouchMouseDown to false', ->
      eventStub = originalEvent:
        preventDefault: ->

      @gameController.onTouchMouseUp eventStub

      (expect @gameController.isTouchMouseDown).toBe false


    it 'should be called when touchMouseUp is triggered on document', ->
      @gameController.isTouchMouseDown = true

      # necessary to trigger 'mouseup' because of 'originalEvent'
      # property which is added through event normalization
      (jQuery document).trigger 'mouseup'

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
      @trackStub = Track.createRecord()
      @trackStub.addPathPoint { x: 10, y: 10 }
      @trackStub.addPathPoint { x: 20, y: 50 }
      @trackStub.addPathPoint { x: 30, y: 40 }

      @gameLoopControllerMock = mockEmberClass GameLoopController,
        start: (renderCallback) ->
          renderCallback()

      @gameController.track = @trackStub
      @gameController.update = sinon.spy()

    afterEach ->
      @gameLoopControllerMock.restore()

    it 'should save timestamp', ->
      @gameController.start()
      (expect @gameController.get 'startTime').toNotBe null

    it 'should start the game loop with #update method as renderCallback', ->
      @gameController.gameLoopController = @gameLoopControllerMock
      @gameController.start()

      (expect @gameController.update).toHaveBeenCalled()

    it 'should set car to startposition', ->
      @gameController.start()
      (expect @gameController.car.get 'position').toEqual { x: 10, y: 10 }


  describe '#finish', ->

    it 'should save timestamp', ->
      @gameController.finish()
      (expect @gameController.endTime).toNotBe null

    it 'should calculate and update race time', ->
      @gameController.finish()
      (expect @gameController.raceTime).toNotBe null

  describe '#restartGame', ->

    beforeEach ->
      @carResetSpy = sinon.spy()
      @carStub = Car.create
        reset: @carResetSpy

    it 'should reset raceTime', ->
      @gameController.raceTime = 18
      @gameController.restartGame()

      (expect @gameController.raceTime).toBe 0

    it 'should reset car', ->
      @gameController.car = @carStub
      @gameController.restartGame()

      (expect @carResetSpy).toHaveBeenCalled()
