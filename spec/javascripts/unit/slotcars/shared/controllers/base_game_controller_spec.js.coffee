describe 'base game controller', ->

  beforeEach ->
    @carMock = mockEmberClass Shared.Car, drive: sinon.spy()
    @trackMock = mockEmberClass Shared.Track

    @baseGameController = Shared.BaseGameController.create
      track: @trackMock
      car: @carMock

  afterEach ->
    @trackMock.restore()
    @carMock.restore()

  it 'should extend Ember.Object', ->
    (expect Shared.BaseGameController).toExtend Ember.Object

  it 'should set isTouchMouseDown to false by default', ->
    (expect @baseGameController.isTouchMouseDown).toBe false

  it 'should set isRaceRunning to false by default', ->
    (expect @baseGameController.isRaceRunning).toBe false

  it 'should throw an error when no track is provided', ->
    (expect => Shared.BaseGameController.create car: @carMock).toThrow()

  it 'should throw an error when no car is provided', ->
    (expect => Shared.BaseGameController.create track: @trackMock).toThrow()

  it 'should create a game loop controller', ->
    @GameLoopControllerMock = mockEmberClass Play.GameLoopController
    Shared.BaseGameController.create
      track: @trackMock
      car: @carMock

    (expect @GameLoopControllerMock.create).toHaveBeenCalledOnce()

    @GameLoopControllerMock.restore()

  describe '#onTouchMouseDown', ->

    it 'should set isTouchMouseDown to true', ->
      eventStub = originalEvent: preventDefault: ->

      @baseGameController.onTouchMouseDown eventStub

      (expect @baseGameController.isTouchMouseDown).toBe true

  describe '#onTouchMouseUp', ->

    it 'should set isTouchMouseDown to false', ->
      eventStub = originalEvent: preventDefault: ->

      @baseGameController.onTouchMouseUp eventStub

      (expect @baseGameController.isTouchMouseDown).toBe false

  describe '#update', ->

    it 'should call the drive function of the car', ->
      @baseGameController.update()

      (expect @carMock.drive).toHaveBeenCalledWith @baseGameController.isTouchMouseDown

  describe '#start', ->

    beforeEach ->
      @gameLoopControllerMock = mockEmberClass Play.GameLoopController,
        start: (renderCallback) -> renderCallback()

      sinon.spy @baseGameController, 'update'

    afterEach ->
      @gameLoopControllerMock.restore()

    it 'should start the game loop with #update method as renderCallback', ->
      @baseGameController.gameLoopController = @gameLoopControllerMock
      @baseGameController.start()

      (expect @baseGameController.update).toHaveBeenCalled()

  describe '#destroy', ->

    beforeEach ->
      @gameLoopControllerStub =
        destroy: sinon.spy()

    it 'should tell the game loop controller to destroy itself', ->
      @baseGameController.gameLoopController = @gameLoopControllerStub
      @baseGameController.destroy()

      (expect @gameLoopControllerStub.destroy).toHaveBeenCalled()

  describe '#onKeyDown', ->
    beforeEach ->
      @correctEvent = keyCode: 32
      @incorrectEvent = keyCode: 42
      @baseGameController.isTouchMouseDown = false

    it 'sets isTouchMouseDown to true when the keyCode matches the spacebar', ->
      @baseGameController.onKeyDown @correctEvent

      (expect @baseGameController.isTouchMouseDown).toBe true

    it 'ignores the event when the keyCode does not match the spacebar', ->
      @baseGameController.onKeyDown @incorrectEvent

      (expect @baseGameController.isTouchMouseDown).toBe false

  describe '#onKeyUp', ->
    beforeEach ->
      @correctEvent = keyCode: 32
      @incorrectEvent = keyCode: 42
      @baseGameController.isTouchMouseDown = true

    it 'sets isTouchMouseDown to false when the keyCode matches the spacebar', ->
      @baseGameController.onKeyUp @correctEvent

      (expect @baseGameController.isTouchMouseDown).toBe false

    it 'ignores the event when the keyCode does not match the spacebar', ->
      @baseGameController.onKeyUp @incorrectEvent

      (expect @baseGameController.isTouchMouseDown).toBe true
