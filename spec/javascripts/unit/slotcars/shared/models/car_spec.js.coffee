
#= require slotcars/shared/models/car
#= require slotcars/shared/lib/movable
#= require slotcars/shared/lib/crashable

#= require helpers/math/vector
#= require slotcars/shared/models/track

describe 'slotcars.shared.models.Car', ->

  Car = slotcars.shared.models.Car
  Vector = helpers.math.Vector
  Movable = slotcars.shared.lib.Movable
  Crashable = slotcars.shared.lib.Crashable
  Track = slotcars.shared.models.Track

  describe 'usage of mixins', ->

    beforeEach ->
      @car = Car.create()

    it 'should use Movable', ->
      (expect Movable.detect @car).toBe true

    it 'should use Crashable', ->
      (expect Crashable.detect @car).toBe true


  describe 'defaults on creation', ->

    beforeEach ->
      @car = Car.create()

    it 'should set speed to zero', ->
      (expect @car.speed).toBe 0

    it 'should set lengthAtTrack', ->
      (expect @car.lengthAtTrack).toBe 0

    it 'should set crashing to false', ->
      (expect @car.isCrashing).toBe false

    it 'should set currentLap to zero', ->
      (expect @car.get 'currentLap').toBe 0


  describe '#accelerate', ->

    beforeEach ->
      @car = Car.create
        acceleration: 1
        speed: 0
        maxSpeed: 1

    it 'should add acceleration value to speed', ->
      @car.accelerate()

      (expect @car.speed).toBe 1

    it 'should not increase speed higher than maxSpeed', ->
      @car.accelerate()
      @car.accelerate()

      (expect @car.speed).toBe 1


  describe '#decelerate', ->

    beforeEach ->
      @car = Car.create
        crashDeceleration: 3
        deceleration: 4
        speed: 5

    it 'should decelerate with standard deceleration when car is on track', ->
      @car.decelerate()

      (expect @car.speed).toBe 1

    it 'should not decrease speed below zero', ->
      @car.decelerate()
      @car.decelerate()

      (expect @car.speed).toBe 0


  describe '#crashcelerate', ->

    beforeEach ->
      @car = Car.create
        crashDeceleration: 3
        speed: 5

    it 'should decelerate with crashDeceleration', ->
      @car.crashcelerate()

      (expect @car.speed).toBe 2

    it 'should not let speed get below zero after crashing', ->
      @car.crashDeceleration = 8
      @car.crashcelerate()

      (expect @car.speed).toBe 0


  describe '#reset', ->

    beforeEach ->
      @car = Car.create
        speed: 10
        lengthAtTrack: 293

    it 'should reset speed', ->
      @car.reset()

      (expect @car.speed).toEqual 0

    it 'should reset lengthAtTrack', ->
      @car.reset()

      (expect @car.lengthAtTrack).toEqual 0
      
    it 'should reset movable', ->
      backup = @car.resetMovable
      @car.resetMovable = sinon.spy()
      
      @car.reset()
      (expect @car.resetMovable).toHaveBeenCalled()
      
      @car.resetMovable = backup;

  describe '#drive', ->

    beforeEach ->
      @car = Car.create speed: 1

    it 'should update lengthAtTrack', ->
      @car.drive()

      (expect @car.lengthAtTrack).toBe 1


  describe 'reactions to changes of length at track', ->

    beforeEach ->
      @trackMock = mockEmberClass Track
      @trackMock.lapForLength = sinon.stub().returns 1
      @trackMock.isLengthAfterFinishLine = sinon.stub().returns false

      @car = Car.create track: @trackMock

    afterEach ->
      @trackMock.restore()


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
        @trackMock.isLengthAfterFinishLine.withArgs(testLength).returns true

        @car.set 'lengthAtTrack', testLength

        (expect @car.get 'crossedFinishLine').toBe true
