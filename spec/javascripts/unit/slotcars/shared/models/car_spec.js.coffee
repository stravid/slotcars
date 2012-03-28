
#= require slotcars/shared/lib/movable
#= require slotcars/shared/lib/crashable

#= require slotcars/shared/models/car
#= require slotcars/shared/models/track

describe 'slotcars.shared.models.Car', ->

  Car = slotcars.shared.models.Car
  Movable = slotcars.shared.lib.Movable
  Crashable = slotcars.shared.lib.Crashable
  Track = slotcars.shared.models.Track

  beforeEach ->
    @trackMock = mockEmberClass Track,
      lapForLength: sinon.spy()
      isLengthAfterFinishLine: sinon.spy()
      getPointAtLength: sinon.spy()

    @car = Car.create
      track: @trackMock

  afterEach ->
    @trackMock.restore()

  describe 'usage of mixins', ->

    it 'should use Movable', ->
      (expect Movable.detect @car).toBe true

    it 'should use Crashable', ->
      (expect Crashable.detect @car).toBe true


  describe 'defaults on creation', ->

    it 'should set speed to zero', ->
      (expect @car.speed).toBe 0

    it 'should set lengthAtTrack', ->
      (expect @car.get 'lengthAtTrack').toBe 0

    it 'should set crashing to false', ->
      (expect @car.isCrashing).toBe false

    it 'should set currentLap to zero', ->
      (expect @car.get 'currentLap').toBe 0


  describe '#reset', ->

    beforeEach ->
      @trackMock.getPointAtLength = sinon.stub().returns { x: 0, y: 0, angle: 10 }

      @car.speed = 10
      @car.set 'lengthAtTrack', 293

    it 'should reset speed', ->
      @car.reset()

      (expect @car.speed).toEqual 0

    it 'should reset lengthAtTrack', ->
      @car.reset()

      (expect @car.get 'lengthAtTrack').toEqual 0

    it 'should move car to start', ->
      sinon.spy @car, 'moveTo'
      @car.reset()

      (expect @car.moveTo).toHaveBeenCalledWith { x: 0, y: 0 }


  describe 'reactions to changes of length at track', ->

    beforeEach ->
      @trackMock.lapForLength = sinon.stub().returns 1
      @trackMock.isLengthAfterFinishLine = sinon.stub().returns false

    describe 'current lap of car', ->

      it 'should update currentLap when lengthAtTrack changes', ->
        @trackMock.lapForLength = sinon.stub().withArgs(1).returns 2

        @car.set 'lengthAtTrack', 2

        (expect @car.get 'currentLap').toBe 2


    describe 'crossing finish line', ->

      it 'should provide property that is false by default', ->
        (expect @car.get 'crossedFinishLine').toBe false

      it 'should be set to true if lengthAtTrack gets bigger than length of finish line', ->
        testLength = 3
        @trackMock.isLengthAfterFinishLine = sinon.stub().withArgs(testLength).returns true

        @car.set 'lengthAtTrack', testLength

        (expect @car.get 'crossedFinishLine').toBe true


  describe 'updating car while moving', ->

    beforeEach ->
      @trackMock.getPointAtLength = sinon.stub().returns { x: 0, y: 0, angle: 10 }

      @car.acceleration = 0.2
      @car.deceleration = 0.4
      @car.crashDeceleration = 0.5
      @car.speed = 5
      @car.maxSpeed = 10

    describe 'when car is on track', ->

      beforeEach ->
        @car.set 'isCrashing', false

      it 'should accelerate car when update is called with true', ->
        currentSpeed = @car.get 'speed'
        @car.update true

        (expect @car.get 'speed').toEqual currentSpeed + @car.acceleration

      it 'should not accelerate above maximum speed', ->
        currentSpeed = @car.get 'speed'
        @car.acceleration = 10
        @car.update true

        (expect @car.get 'speed').toEqual @car.maxSpeed

      it 'should decelerate car when update is called with false', ->
        currentSpeed = @car.get 'speed'
        @car.update false

        (expect @car.get 'speed').toEqual currentSpeed - @car.deceleration

      it 'should not decelerate car below zero', ->
        currentSpeed = @car.get 'speed'
        @car.deceleration = 10
        @car.update false

        (expect @car.get 'speed').toEqual 0

      it 'should move car', ->
        sinon.spy @car, 'set'
        sinon.spy @car, 'moveTo'
        @car.update false  # does not matter wether true or false

        (expect @car.set).toHaveBeenCalledWith 'lengthAtTrack'
        (expect @car.moveTo).toHaveBeenCalled()

      it 'should check for crash', ->
        @trackMock.getPointAtLength = sinon.stub().returns { x: 5, y: 5, angle: 15 }
        sinon.spy @car, 'checkForCrash'
        @car.update false # does not matter wether true or false

        (expect @car.checkForCrash).toHaveBeenCalledWith { x: 5, y: 5, angle: 15 }

    describe 'when car is crashing', ->

      beforeEach ->
        @car.update false # simulates normal driving mode
        @car.set 'isCrashing', true

      it 'should slow down', ->
        currentSpeed = @car.get 'speed'
        @car.update false

        (expect @car.get 'speed').toEqual currentSpeed - @car.crashDeceleration

      it 'should not decelerate car below zero', ->
        currentSpeed = @car.get 'speed'
        @car.crashDeceleration = 10
        @car.update false

        (expect @car.get 'speed').toEqual 0

      it 'should not be possible to accelerate the car', ->
        currentSpeed = @car.get 'speed'
        @car.update true

        (expect @car.get 'speed').toEqual currentSpeed - @car.crashDeceleration

      it 'should update the car´s position', ->
        sinon.spy @car, 'crash'
        @car.update false

        (expect @car.crash).toHaveBeenCalledOnce()
