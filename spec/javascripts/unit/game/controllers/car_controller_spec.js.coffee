
#= require game/controllers/car_controller
#= require vendor/raphael
#= require shared/models/track_model

describe 'game.controllers.CarController (unit)', ->

  CarController = game.controllers.CarController
  TrackModel = shared.models.TrackModel

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarController).toBe true

  beforeEach ->
    @path = "M10,20L30,40"

    @trackMediatorStub = Ember.Object.create
      currentTrack: TrackModel._create
        path: @path

    @carMediatorStub = Ember.Object.create
      position:
        x: 0
        y: 0

    @car = CarController.create
      carMediator: @carMediatorStub
      trackMediator: @trackMediatorStub

  describe 'defaults on creation', ->

    it 'should set speed to zero', ->
      (expect @car.speed).toBe 0

    it 'should set lengthAtTrack', ->
      (expect @car.lengthAtTrack).toBe 0

    it 'should set crashing to false', ->
      (expect @car.crashing).toBe false


  describe '#init', ->

    it 'should set car position on mediator', ->
      expectedPoint = @trackMediatorStub.currentTrack.getPointAtLength 0

      (expect @carMediatorStub.position.x).toEqual expectedPoint.x
      (expect @carMediatorStub.position.y).toEqual expectedPoint.y


  describe '#accelerate', ->

    beforeEach ->
      @car.speed =  0
      @car.acceleration = 10
      @car.maxSpeed = 10

    it 'should increase speed', ->
      @car.accelerate()
      (expect @car.speed).toEqual 10

    it 'should not set speed higher than maxSpeed', ->
      @car.accelerate()
      @car.accelerate()
      (expect @car.speed).toEqual 10


  describe '#slowDown', ->

    beforeEach ->
      @car.speed =  10
      @car.deceleration = 10

    it 'should decrease speed', ->
      @car.slowDown()
      (expect @car.speed).toEqual 0

    it 'should not set speed < 0', ->
      @car.slowDown()
      @car.slowDown()
      (expect @car.speed).toEqual 0

  describe '#drive', ->

    describe 'random speed', ->

      beforeEach ->
        @speedValue = Math.random 1
        @car.speed = @speedValue

      it 'should update the car position', ->
        @car.drive()

        point = @trackMediatorStub.currentTrack.getPointAtLength @speedValue

        (expect @carMediatorStub.position.x).toBe point.x
        (expect @carMediatorStub.position.y).toBe point.y

    describe 'deterministic speed', ->

      beforeEach ->
        @car.speed = 30 # static path we use for tests has length ~ 28
        @spy = sinon.spy()

        ($ @car).on 'crossFinishLine', => @spy()

      it 'should fire "crossed finish line" event', ->
        @car.drive()

        (expect @spy).toHaveBeenCalledOnce()


    describe 'crash & respawn', ->

      beforeEach ->
        @getPointAtLengthStub = sinon.stub @trackMediatorStub.currentTrack, 'getPointAtLength'

        # mocks curve angle of 90 degrees
        (@getPointAtLengthStub.withArgs 0).returns x: 0, y:0
        (@getPointAtLengthStub.withArgs 1).returns x: 1, y:0
        (@getPointAtLengthStub.withArgs 2).returns x: 1, y:1

      afterEach ->
        @getPointAtLengthStub.restore()


      describe 'crashing', ->

        it 'should set crashing to true when too fast in curve', ->
          @car.speed = 1
          @car.traction = 89 # loses vs. speed * angle || 1 * 90 = 90

          @car.drive()

          (expect @car.crashing).toBe true

        it 'should not set crashing when traction is high enough', ->
          @car.speed = 1
          @car.traction = 91 # wins vs. speed * angle || 1 * 90 = 90

          @car.drive()

          (expect @car.crashing).toBe false

        it 'should not update car as normal while crashing', ->
          @car.speed = 1
          @car.traction = 30

          @car.drive()

          (expect => @car.drive()).not.toThrow()

        it 'should keep driving into direction of last vector', ->
          @car.speed = 1
          @car.traction = 30
          @car.offRoadDeceleration = 0

          @car.drive()
          @car.drive()

          # drives 2 times in direction x: 1, y: 0
          (expect @carMediatorStub.position.x).toBe 2

        it 'should not be possible to accelerate the car when crashing', ->
          @car.speed = 1
          @car.traction = 30

          @car.drive() # crash

          @car.accelerate()

          (expect @car.speed).toBe 1


      describe 'respawning', ->

        beforeEach ->
          # let car crash
          @car.speed = 1
          @car.traction = 30
          @car.drive()

          (@getPointAtLengthStub.withArgs 3).returns x: 2, y:2


        it 'should set crashing to false when car stopped moving', ->
          @car.speed = 0

          @car.drive()

          (expect @car.crashing).toBe false

        it 'should set car on last position on track', ->
          @car.drive() # drive into crash direction
          @car.drive() # drive into crash direction

          @car.speed = 0 # slow car down

          @car.drive() # sets crashing to false

          @car.speed = 1 # simulate acceleration

          @car.drive() # drive on path again

          (expect @carMediatorStub.position.x).toBe 1
          (expect @carMediatorStub.position.y).toBe 1



  describe '#reset', ->

    beforeEach ->
      @car.speed = 10
      @car._updateCarPosition = sinon.spy()

    it 'should reset speed', ->
      @car.reset()

      (expect @car.speed).toEqual 0

    it 'should reset lengthAtTrack', ->
      @car.drive()
      @car.reset()

      (expect @car.lengthAtTrack).toEqual 0

    it 'should call _updateCarPosition', ->
      @car.reset()

      (expect @car._updateCarPosition).toHaveBeenCalledOnce()


