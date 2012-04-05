
#= require slotcars/shared/controllers/base_game_controller
#= require slotcars/play/controllers/game_loop_controller

#= require slotcars/shared/models/track
#= require slotcars/shared/models/car

describe 'base game controller', ->

  BaseGameController = Slotcars.shared.controllers.BaseGameController
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

    @baseGameController = BaseGameController.create
      track: @trackMock
      car: @carMock

  afterEach ->
    @trackMock.restore()
    @carMock.restore()

  it 'should extend Ember.Object', ->
    (expect BaseGameController).toExtend Ember.Object

  it 'should set isTouchMouseDown to false by default', ->
    (expect @baseGameController.isTouchMouseDown).toBe false

  it 'should set carControlsEnabled to false by default', ->
    (expect @baseGameController.carControlsEnabled).toBe false

  it 'should throw an error when no track is provided', ->
    (expect => BaseGameController.create car: Car.create()).toThrow()

  it 'should throw an error when no car is provided', ->
    (expect => BaseGameController.create track: @trackMock).toThrow()

  it 'should create a game loop controller', ->
    @GameLoopControllerMock = mockEmberClass GameLoopController
    BaseGameController.create
      track: @trackMock
      car: Car.create()

    (expect @GameLoopControllerMock.create).toHaveBeenCalledOnce()
    
    @GameLoopControllerMock.restore()

  describe '#onTouchMouseDown', ->

    it 'should set isTouchMouseDown to true', ->
      eventStub = originalEvent: preventDefault: ->

      @baseGameController.onTouchMouseDown eventStub

      (expect @baseGameController.isTouchMouseDown).toBe true

  describe '#onTouchMouseUp', ->

    it 'should set isTouchMouseDown to false', ->
      eventStub = originalEvent:
        preventDefault: ->

      @baseGameController.onTouchMouseUp eventStub

      (expect @baseGameController.isTouchMouseDown).toBe false

  describe '#update', ->

    it 'should call the update function of the car', ->
      @baseGameController.update()

      (expect @carMock.update).toHaveBeenCalledWith @baseGameController.isTouchMouseDown

  describe '#start', ->

    beforeEach ->
      @gameLoopControllerMock = mockEmberClass GameLoopController,
        start: (renderCallback) ->
          renderCallback()

      @updateSpy = sinon.spy @baseGameController, 'update'

    afterEach ->
      @gameLoopControllerMock.restore()

    it 'should start the game loop with #update method as renderCallback', ->
      @baseGameController.gameLoopController = @gameLoopControllerMock
      @baseGameController.start()

      (expect @updateSpy).toHaveBeenCalled()