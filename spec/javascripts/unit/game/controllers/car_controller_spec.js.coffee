
#= require vendor/raphael

#= require game/controllers/car_controller
#= require shared/models/track_model
#= require shared/mediators/current_track_mediator
#= require game/mediators/car_mediator

#= require game/lib/car

describe 'game.controllers.CarController (unit)', ->

  CarController = game.controllers.CarController
  Car = game.lib.Car
  TrackModel = shared.models.TrackModel
  currentTrackMediator = shared.mediators.currentTrackMediator

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarController).toBe true

  beforeEach ->
    @path = "M10,20L30,40"

    currentTrackMediator.set 'currentTrack', TrackModel._create
      path: @path

    @car = Car.create()

  afterEach ->
    currentTrackMediator.set 'currentTrack', null
    @car.set 'position', { x: 0, y: 0 }


  describe '#drive', ->

    describe 'random speed', ->

      beforeEach ->
        @car.speed = @speedValue = Math.random 1

      it 'should update the car position', ->
        @car.drive()

        point = currentTrackMediator.currentTrack.getPointAtLength @speedValue

        (expect @car.get 'position').toEqual { x: point.x, y: point.y }

    # describe 'deterministic speed', ->

    #   beforeEach ->
    #     @car.speed = currentTrackMediator.currentTrack.totalLength + 1
    #     @spy = sinon.spy()

    #     ($ @car).on 'crossFinishLine', => @spy()

    #   it 'should fire "crossed finish line" event', ->
    #     @car.drive()

    #     (expect @spy).toHaveBeenCalledOnce()


    describe 'crash & respawn', ->

      beforeEach ->
        @getPointAtLengthStub = sinon.stub currentTrackMediator.currentTrack, 'getPointAtLength'

        # mocks curve angle of 90 degrees
        (@getPointAtLengthStub.withArgs 0).returns x: 0, y:0
        (@getPointAtLengthStub.withArgs 1).returns x: 1, y:0
        (@getPointAtLengthStub.withArgs 2).returns x: 1, y:1

      afterEach ->
        @getPointAtLengthStub.restore()


      describe 'crashing', ->

        # it 'should set crashing to true when too fast in curve', ->
        #   @car.speed = 1
        #   @car.traction = 89 # loses vs. speed * angle || 1 * 90 = 90
        # 
        #   @car.drive()
        # 
        #   (expect @car.crashing).toBe true
        # 
        # it 'should not set crashing when traction is high enough', ->
        #   @car.speed = 1
        #   @car.traction = 91 # wins vs. speed * angle || 1 * 90 = 90
        # 
        #   @car.drive()
        # 
        #   (expect @car.crashing).toBe false

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
          (expect (@car.get 'position').x).toBe 2

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

          (expect @car.get 'position').toEqual { x: 1, y: 1 }



  # describe '#reset', ->

  #   beforeEach ->
  #     @car.speed = 10

  #   it 'should reset speed', ->
  #     @car.reset()

  #     (expect @car.speed).toEqual 0

  #   it 'should reset lengthAtTrack', ->
  #     @car.drive()
  #     @car.reset()

  #     (expect @car.lengthAtTrack).toEqual 0

