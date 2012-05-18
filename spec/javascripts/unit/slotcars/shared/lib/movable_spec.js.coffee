describe 'Shared.Movable', ->

  beforeEach ->
    @trackMock = mockEmberClass Shared.Track
    @movable = Ember.Object.extend(Shared.Movable).create track: @trackMock

  afterEach -> @trackMock.restore()


  describe 'moving along track', ->

    beforeEach ->
      sinon.stub @movable, 'getNextRotation'
      sinon.stub @movable, 'getNextPosition'
      sinon.stub @movable, 'getNextLengthAtTrack'

    it 'should get the next rotation and set it for the car', ->
      testRotation = 3
      @movable.getNextRotation.returns testRotation

      @movable.moveAlongTrack()

      (expect @movable.rotation).toBe testRotation

    it 'should get the next position and set it for the car', ->
      testPosition = 3
      @movable.getNextPosition.returns testPosition

      @movable.moveAlongTrack()

      (expect @movable.position).toBe testPosition

    it 'should get the next length at track and set it for the car', ->
      testLengthAtTrack = 3
      @movable.getNextLengthAtTrack.returns testLengthAtTrack

      @movable.moveAlongTrack()

      (expect @movable.lengthAtTrack).toBe testLengthAtTrack


  describe 'moving to start position', ->

    beforeEach -> sinon.stub @movable, 'moveAlongTrack'

    it 'should reset speed and length at track', ->

      # random values for properties which should be reset
      @movable.set 'speed', 1
      @movable.set 'lengthAtTrack', 1

      @movable.moveToStartPosition()

      (expect @movable.speed).toBe 0
      (expect @movable.lengthAtTrack).toBe 0

    it 'should move to next position', ->
      @movable.moveToStartPosition()

      (expect @movable.moveAlongTrack).toHaveBeenCalled()


  describe 'getting next position on track', ->

    beforeEach ->
      @trackMock.getPointAtLength = sinon.stub()
      sinon.stub @movable, 'getNextLengthAtTrack'

    it 'should update next position based on next length at track', ->
      testLengthAtTrack = 9
      @movable.getNextLengthAtTrack.returns testLengthAtTrack
      testPointAtLength = {}
      (@trackMock.getPointAtLength.withArgs testLengthAtTrack).returns testPointAtLength

      resultingPosition = @movable.getNextPosition()

      (expect resultingPosition).toBe testPointAtLength


  describe 'calculating the next rotation on track', ->

    beforeEach ->
      @vectorMock = mockEmberClass Shared.Vector, clockwiseAngle: sinon.stub()
      @trackMock.getPointAtLength = sinon.stub()
      sinon.stub @movable, 'getNextPosition'

    afterEach -> @vectorMock.restore()


    it 'should get position for previous length at track', ->
      testLengthAtTrack = 1
      @movable.set 'lengthAtTrack', testLengthAtTrack

      @movable.getNextRotation()

      (expect @trackMock.getPointAtLength).toHaveBeenCalledWith testLengthAtTrack - 0.1

    it 'should create direction from calculated positions', ->
      previousPosition = {}
      nextPosition = {}

      @movable.getNextPosition.returns nextPosition
      @trackMock.getPointAtLength.returns previousPosition

      @movable.getNextRotation()

      (expect Shared.Vector.create).toHaveBeenCalledWithAnObjectLike from: previousPosition, to: nextPosition

    it 'should set next rotation to clockwise angle of calculated direction', ->
      testAngle = {}
      @vectorMock.clockwiseAngle.returns testAngle

      resultingAngle = @movable.getNextRotation()

      (expect resultingAngle).toBe testAngle