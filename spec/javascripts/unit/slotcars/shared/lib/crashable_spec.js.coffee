
describe 'Shared.Crashable', ->

  beforeEach ->
    @trackMock = mockEmberClass Shared.Track
    @crashable = Ember.Object.extend(Shared.Movable, Shared.Drivable, Shared.Crashable).create
      track: @trackMock

  afterEach -> @trackMock.restore()


  describe 'crashing', ->

    it 'should set crashing to true', ->
      @crashable.crash()

      (expect @crashable.isCrashing).toBe true


  describe 'calculating if car is too fast in curve', ->

    it 'should return true if calculated angle speed is bigger than traction', ->
      # formular: angle * speedPercentageMultiplier + speed * speedPercentageMultiplier
      @crashable.set 'maxSpeed', 10
      # speedPercentageMultiplier = 2 in this example
      @crashable.set 'speed', 10
      testAngle = 10

      # the calculation is 40, so stay lower here
      @crashable.set 'traction', 39

      @crashable.set 'direction', angleFrom: sinon.stub().returns testAngle

      (expect @crashable.isTooFastInCurve()).toBe true

    it 'should return false if speed multiplied by angle is smaller than traction', ->
      # formular: angle * speedPercentageMultiplier + speed * speedPercentageMultiplier
      @crashable.set 'maxSpeed', 10
      # speedPercentageMultiplier = 2 in this example
      @crashable.set 'speed', 10
      testAngle = 10

      # the calculation is 40, so stay higher here
      @crashable.set 'traction', 41

      @crashable.set 'direction', angleFrom: sinon.stub().returns testAngle

      (expect @crashable.isTooFastInCurve()).toBe false

    it 'should return false if speed is zero', ->
      # formular: angle * speedPercentageMultiplier + speed * speedPercentageMultiplier
      @crashable.set 'speed', 0
      testAngle = 10
      # the calculation is 10, so stay lower here so it would crash normally
      @crashable.set 'traction', 9

      @crashable.set 'direction', angleFrom: sinon.stub().returns testAngle

      (expect @crashable.isTooFastInCurve()).toBe false


  describe 'updating direction', ->

    it 'should set direction to value of next direction', ->
      testDirection = {}
      @crashable.set 'nextDirection', testDirection

      @crashable.updateDirection()

      (expect @crashable.direction).toBe testDirection


  describe 'checking for crash end', ->

    it 'should set crashing to false if speed is zero or smaller', ->
      @crashable.set 'speed', 0
      @crashable.set 'isCrashing', true

      @crashable.checkForCrashEnd()

      (expect @crashable.isCrashing).toBe false


  describe 'slowing down crashing car', ->

    it 'should subtract crash deceleration from speed', ->
      @crashable.set 'speed', 1
      @crashable.set 'crashDeceleration', 1

      @crashable.slowDownCrashingCar()

      (expect @crashable.speed).toBe 0

    it 'should clamp the decelerated speed to min speed', ->
      @crashable.set 'speed', 1
      @crashable.set 'crashDeceleration', 2

      @crashable.slowDownCrashingCar()

      (expect @crashable.speed).toBe 0


  describe 'checking for crash', ->

    beforeEach ->
      @vectorMock = mockEmberClass Shared.Vector
      sinon.stub @crashable, 'getNextPosition'
      sinon.stub @crashable, 'updateDirection'
      sinon.stub @crashable, 'isTooFastInCurve'
      sinon.stub @crashable, 'updateTorque'

    afterEach -> @vectorMock.restore()

    it 'should set direction to calculated next direction if it is null', ->
      @crashable.checkForCrash()

      (expect @crashable.direction).toBe @vectorMock

    it 'should crash if car is too fast in curve', ->
      @crashable.set 'direction', {}
      @crashable.isTooFastInCurve.returns true
      sinon.stub @crashable, 'crash'

      @crashable.checkForCrash()

      (expect @crashable.crash).toHaveBeenCalled()

    it 'should update direction if car is not too fast in curve', ->
      @crashable.set 'direction', {}
      @crashable.isTooFastInCurve.returns false

      @crashable.checkForCrash()

      (expect @crashable.updateDirection).toHaveBeenCalled()

    it 'should update torque if not too fast in curve', ->
      @crashable.set 'direction', {}
      @crashable.isTooFastInCurve.returns false

      @crashable.checkForCrash()

      (expect @crashable.updateTorque).toHaveBeenCalled()


  describe 'moving car in crashing direction', ->

    beforeEach ->
      sinon.stub @crashable, 'slowDownCrashingCar'
      sinon.stub @crashable, 'checkForCrashEnd'
      sinon.stub @crashable, 'calculateNextCrashingPosition'
      sinon.stub @crashable, 'getCrashVector'
      sinon.stub @crashable, 'rotateCrashingCar'

    it 'should slow down crashing car', ->
      @crashable.moveCarInCrashingDirection()

      (expect @crashable.slowDownCrashingCar).toHaveBeenCalled()

    it 'should calculate next crashing position', ->
      testCrashVector = {}
      @crashable.getCrashVector.returns testCrashVector

      @crashable.moveCarInCrashingDirection()

      (expect @crashable.calculateNextCrashingPosition).toHaveBeenCalledWith testCrashVector

    it 'should check for crash end', ->
      @crashable.moveCarInCrashingDirection()

      (expect @crashable.checkForCrashEnd).toHaveBeenCalled()

    it 'should rotate crashing car', ->
      @crashable.moveCarInCrashingDirection()

      (expect @crashable.rotateCrashingCar).toHaveBeenCalled()


  describe 'getting next crash vector', ->

    it 'should normalize and scale current direction with speed', ->
      returnedDirection = {}

      fakeDirection =
        normalize: -> this
        scale: sinon.stub().returns returnedDirection

      @crashable.set 'direction', fakeDirection

      crashVector = @crashable.getCrashVector()

      (expect crashVector).toBe returnedDirection


  describe 'calculating next crashing position', ->

    it 'should add crash vector to current position and return that position', ->
      @crashable.set 'position', x: 1, y: 2

      returnedPosition = @crashable.calculateNextCrashingPosition x: 3, y: 2

      (expect returnedPosition).toEqual x: 4, y: 4


  describe 'rotating crashing car', ->

    beforeEach ->
      sinon.stub @crashable, 'reduceTorque'

    it 'should add torque to rotation', ->
      testTorque = 1
      testRotation = 1
      @crashable.set 'torque', testTorque
      @crashable.set 'rotation', testRotation

      @crashable.rotateCrashingCar()

      (expect @crashable.rotation).toBe testTorque + testRotation

    it 'should reduce torque', ->
      @crashable.rotateCrashingCar()

      (expect @crashable.reduceTorque).toHaveBeenCalled()


  describe 'reducing torque', ->

    it 'should multiply torque with minimizeMultiplier', ->
      testTorque = 1
      testTorqueMinimizeMultiplier = 0.5

      @crashable.set 'torque', testTorque
      @crashable.set 'torqueMinimizeMultiplier', testTorqueMinimizeMultiplier

      @crashable.reduceTorque()

      (expect @crashable.torque).toBe testTorque * testTorqueMinimizeMultiplier