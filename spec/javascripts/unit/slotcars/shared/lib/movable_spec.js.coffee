describe 'Shared.Movable', ->

  beforeEach ->
    @trackMock = mockEmberClass Shared.Track
    @movable = Ember.Object.extend(Shared.Movable).create track: @trackMock

  afterEach -> @trackMock.restore()


  describe 'moving to next position', ->

    beforeEach ->
      sinon.stub @movable, 'calculateNextPosition'
      sinon.stub @movable, 'calculateNextRotation'

    it 'should calculate its next position', ->
      @movable.moveToNextPosition()

      (expect @movable.calculateNextPosition).toHaveBeenCalled()

    it 'should calculate its next rotation', ->
      @movable.moveToNextPosition()

      (expect @movable.calculateNextRotation).toHaveBeenCalled()

    it 'should update all properties to the calculated ones', ->
      @movable.set 'nextLengthAtTrack', 1
      @movable.set 'nextPosition', { x: 1, y: 1 }
      @movable.set 'nextRotation', 30

      @movable.moveToNextPosition()

      (expect @movable.get 'lengthAtTrack').toEqual @movable.get 'nextLengthAtTrack'
      (expect @movable.get 'position').toEqual @movable.get 'nextPosition'
      (expect @movable.get 'rotation').toEqual @movable.get 'nextRotation'


  describe 'moving along track', ->

    beforeEach -> sinon.stub @movable, 'moveToNextPosition'

    it 'should calculate and update the next length at track based on current speed', ->
      currentSpeed = 9
      @movable.set 'speed', currentSpeed

      @movable.moveAlongTrack()

      (expect @movable.nextLengthAtTrack).toBe currentSpeed #default length at track is zero

    it 'should move to next position', ->
      @movable.moveAlongTrack()

      (expect @movable.moveToNextPosition).toHaveBeenCalled()


  describe 'moving to start position', ->

    beforeEach -> sinon.stub @movable, 'moveToNextPosition'

    it 'should reset speed and length at track', ->

      # random values for properties which should be reset
      @movable.set 'speed', 1
      @movable.set 'lengthAtTrack', 1
      @movable.set 'nextLengthAtTrack', 9

      @movable.moveToStartPosition()

      (expect @movable.speed).toBe 0
      (expect @movable.lengthAtTrack).toBe 0
      (expect @movable.nextLengthAtTrack).toBe 0

    it 'should move to next position', ->
      @movable.moveToStartPosition()

      (expect @movable.moveToNextPosition).toHaveBeenCalled()


  describe 'calculating next position on track', ->

    beforeEach -> @trackMock.getPointAtLength = sinon.stub()

    it 'should update next position based on next length at track', ->
      testLengthAtTrack = 9
      @movable.set 'nextLengthAtTrack', testLengthAtTrack
      testPointAtLength = {}
      @trackMock.getPointAtLength.returns testPointAtLength

      @movable.calculateNextPosition()

      (expect @trackMock.getPointAtLength).toHaveBeenCalledWith testLengthAtTrack
      (expect @movable.nextPosition).toBe testPointAtLength


  describe 'calculating the next rotation on track', ->

    beforeEach ->
      @vectorMock = mockEmberClass Shared.Vector, clockwiseAngle: sinon.stub()
      @trackMock.getPointAtLength = sinon.stub()

    afterEach -> @vectorMock.restore()


    it 'should get position for previous length at track', ->
      testLengthAtTrack = 1
      @movable.set 'lengthAtTrack', testLengthAtTrack

      @movable.calculateNextRotation()

      (expect @trackMock.getPointAtLength).toHaveBeenCalledWith testLengthAtTrack - 0.1

    it 'should create direction from calculated positions', ->
      previousPosition = {}
      nextPosition = {}

      @movable.set 'nextPosition', nextPosition
      @trackMock.getPointAtLength.returns previousPosition

      @movable.calculateNextRotation()

      (expect Shared.Vector.create).toHaveBeenCalledWithAnObjectLike from: previousPosition, to: nextPosition

    it 'should set next rotation to clockwise angle of calculated direction', ->
      testAngle = {}
      @vectorMock.clockwiseAngle.returns testAngle

      @movable.calculateNextRotation()

      (expect @movable.nextRotation).toBe testAngle