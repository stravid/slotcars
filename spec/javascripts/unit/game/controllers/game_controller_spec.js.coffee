
#= require game/controllers/game_controller
#= require game/controllers/car_controller

#= require game/mediators/game_mediator

#= require game/views/track_view
#= require game/views/game_view

#= require shared/models/track_model
#= require game/lib/car

describe 'game.controllers.GameController (unit)', ->

  GameController = game.controllers.GameController
  GameView = game.views.GameView
  TrackModel = shared.models.TrackModel
  Car = game.lib.Car

  beforeEach ->
    @trackStub =
      getPointAtLength: -> sinon.stub().returns { x: 0, y: 0 }

    @gameController = GameController.create
      track: @trackStub

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect GameController).toBe true

  it 'should set isTouchMouseDown to false by default', ->
    (expect @gameController.isTouchMouseDown).toBe false

  it 'should throw an error when no track is passed', ->
    (expect => GameController.create()).toThrow()

  it 'should create a car', ->
    (expect @gameController.car).not.toBe null


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
      @car = game.lib.Car.create()

      @accelerateStub = sinon.stub @car, 'accelerate'
      @decelerateStub = sinon.stub @car, 'decelerate'
      @moveStub = sinon.stub @car, 'moveTo'

      @gameController.car = @car

    afterEach ->
      @car.accelerate.restore()
      @car.moveTo.restore()
      @car.decelerate.restore()

    it 'should accelerate car when isTouchMouseDown is true', ->
      @gameController.isTouchMouseDown = true

      @gameController.update()

      (expect @accelerateStub).toHaveBeenCalledOnce()

    it 'should slowDown when isTouchMouseDown is false', ->
      @gameController.isTouchMouseDown = false

      @gameController.update()

      (expect @decelerateStub).toHaveBeenCalledOnce()
      (expect @accelerateStub).not.toHaveBeenCalled()

    it 'should drive car', ->
      @gameController.update()

      (expect @moveStub).toHaveBeenCalledOnce()


  describe '#start', ->

    beforeEach ->
      path = helpers.math.Path.create points: [
        {x: 10, y:10, angle: 0}
        {x: 20, y:50, angle: 0}
      ]

      @trackStub = TrackModel.createRecord()
      @trackStub.setPointPath path

      @gameController = GameController.create
        track: @trackStub
        gameLoopController:
          start: ->
        update: ->

    it 'should save timestamp', ->
      @gameController.start()
      (expect @gameController.startTime).toNotBe null

    it 'should start the game loop with #update method as renderCallback', ->
      @gameLoopControllerStub =
        start: (renderCallback) ->
          renderCallback()

      @gameControllerUpdateStub = sinon.spy()

      @gameController.gameLoopController = @gameLoopControllerStub
      @gameController.update = @gameControllerUpdateStub

      @gameController.start()

      (expect @gameControllerUpdateStub).toHaveBeenCalled()

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

    it 'should call finish when crossFinishLine event was triggered in CarController', ->
      finishSpy = sinon.spy()
      @gameController.finish = finishSpy

      (jQuery @gameController.car).trigger 'crossFinishLine'
      (expect finishSpy).toHaveBeenCalled()


  describe '#restartGame', ->

    beforeEach ->
      @carResetSpy = sinon.spy()
      @carStub = Car.create
        reset: @carResetSpy

    it 'should call restartGame when restartGame event was triggered', ->
      restartGameSpy = sinon.spy()

      gameController = GameController.create
        track: @trackStub
        gameView: GameView.create()
        restartGame: restartGameSpy

      (jQuery gameController.gameView).trigger 'restartGame'
      (expect restartGameSpy).toHaveBeenCalledOnce()

    it 'should reset raceTime', ->
      gameController = GameController.create
        track: @trackStub

      gameController.raceTime = 18
      gameController.restartGame()

      (expect gameController.raceTime).toBe 0

    it 'should reset car', ->
      gameController = GameController.create
        track: @trackStub

      gameController.car = @carStub
      gameController.restartGame()

      (expect @carResetSpy).toHaveBeenCalled()
