describe 'Shared.Car', ->

  beforeEach ->
    @trackMock = mockEmberClass Shared.Track,
      lapForLength: sinon.spy()
      isLengthAfterFinishLine: sinon.spy()

    @car = Shared.Car.create track: @trackMock

  afterEach -> @trackMock.restore()


  describe 'usage of mixins', ->

    it 'should use Movable', -> (expect Shared.Movable.detect @car).toBe true
    it 'should use Drivable', -> (expect Shared.Drivable.detect @car).toBe true
    it 'should use Crashable', -> (expect Shared.Crashable.detect @car).toBe true


  describe 'defaults on creation', ->

    it 'should set currentLap to zero', -> (expect @car.get 'currentLap').toBe 0


  describe '#reset', ->

    beforeEach -> sinon.stub @car, 'moveToStartPosition'

    it 'should move the car to start position', ->
      @car.reset()

      (expect @car.moveToStartPosition).toHaveBeenCalled()


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


  describe 'driving the car', ->

    describe 'while on track', ->

      beforeEach ->
        sinon.stub @car, 'accelerate'
        sinon.stub @car, 'moveAlongTrack'

      it 'should accelerate when drive was called with true', ->
        @car.drive true

        (expect @car.accelerate).toHaveBeenCalledWith true

      it 'should decelerate when drive was called with false', ->
        @car.drive false

        (expect @car.accelerate).toHaveBeenCalledWith false

      it 'should move along track', ->
        @car.drive true

        (expect @car.moveAlongTrack).toHaveBeenCalled()


    describe 'while crashing', ->

      beforeEach -> sinon.stub @car, 'moveCarInCrashingDirection'

      it 'should accelerate when drive was called with true', ->
        @car.set 'isCrashing', true

        @car.drive true

        (expect @car.moveCarInCrashingDirection).toHaveBeenCalled()