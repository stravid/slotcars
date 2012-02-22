
#= require game/controllers/car_controller
#= require vendor/raphael

describe 'game.controllers.CarController (unit)', ->

  CarController = game.controllers.CarController

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarController).toBe true

  describe 'defaults on creation', ->

    beforeEach ->
      @car = CarController.create()

    it 'should set speed to zero', ->
      (expect @car.speed).toBe 0

    it 'should set lengthAtTrack', ->
      (expect @car.lengthAtTrack).toBe 0

    it 'should set crashing to false', ->
      (expect @car.crashing).toBe false


  describe '#setTrackPath', ->

    beforeEach ->
      @path = "M10,20L30,40"
      @mediatorStub = Ember.Object.create
        position:
          x: 0
          y: 0

      @car = CarController.create
        trackPath: @path
        lengthAtTrack: 5
        mediator: @mediatorStub


    it 'should reset lengthAtTrack to zero', ->
      @car.setTrackPath @path

      (expect @car.lengthAtTrack).toBe 0

    it 'should reset car position on mediator', ->
      @car.setTrackPath @path

      expectedPoint = Raphael.getPointAtLength @path, 0

      (expect @mediatorStub.position.x).toEqual expectedPoint.x
      (expect @mediatorStub.position.y).toEqual expectedPoint.y

    it 'should calculate the track length when the path changes', ->
      @car.setTrackPath @path

      (expect @car.trackLength).toEqual Raphael.getTotalLength @path

  describe '#accelerate', ->

    beforeEach ->
      @car = CarController.create
        speed: 0
        acceleration: 10
        maxSpeed: 10

    it 'should increase speed', ->
      @car.accelerate()
      (expect @car.speed).toEqual 10

    it 'should not set speed higher than maxSpeed', ->
      @car.accelerate()
      @car.accelerate()
      (expect @car.speed).toEqual 10


  describe '#slowDown', ->

    beforeEach ->
      @car = CarController.create
        speed: 10
        deceleration: 10

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
        @mediatorStub = Ember.Object.create
          position:
            x: 0
            y: 0

        @car = CarController.create
          speed: @speedValue
          mediator: @mediatorStub

        @path = "M10,20L30,40"
        @car.setTrackPath @path

      it 'should update the car position', ->
        @car.drive()

        point = Raphael.getPointAtLength @path, @speedValue

        (expect @mediatorStub.position.x).toBe point.x
        (expect @mediatorStub.position.y).toBe point.y

    describe 'deterministic speed', ->

      beforeEach ->
        @speedValue = 10
        @mediatorStub = Ember.Object.create
          position:
            x: 0
            y: 0

        @car = CarController.create
          speed: @speedValue
          mediator: @mediatorStub

        @spy = sinon.spy()

        ($ @car).on 'crossFinishLine', => @spy()

        @path = "M0,0L5,0"
        @car.setTrackPath @path

      it 'should fire "crossed finish line" event', ->
        @car.drive()

        (expect @spy).toHaveBeenCalledOnce()


    describe 'crashing', ->

      beforeEach ->
        @getPointAtLengthStub = sinon.stub Raphael, 'getPointAtLength'
        @mediatorStub = Ember.Object.create
          position: {}

        @car = CarController.create
          mediator: @mediatorStub

        # mocks curve angle of 90 degrees
        (@getPointAtLengthStub.withArgs @car.path, 0).returns x: 0, y:0
        (@getPointAtLengthStub.withArgs @car.path, 1).returns x: 1, y:0
        (@getPointAtLengthStub.withArgs @car.path, 2).returns x: 1, y:1

      afterEach ->
        @getPointAtLengthStub.restore()


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

        @car.drive()
        @car.drive()

        # drives 2 times in direction x: 1, y: 0
        (expect @mediatorStub.position.x).toBe 2



  describe '#reset', ->

    beforeEach ->
      @mediatorStub = Ember.Object.create
          position:
            x: 0
            y: 0

      @car = CarController.create
        speed: 10
        mediator: @mediatorStub

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


