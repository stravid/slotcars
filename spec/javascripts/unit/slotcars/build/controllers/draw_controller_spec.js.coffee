describe 'Build.DrawController', ->

  it 'should be an Ember.Object', ->
    (expect Build.DrawController).toExtend Ember.Object

  beforeEach ->
    @buildScreenStateManagerMock = mockEmberClass Build.BuildScreenStateManager, send: sinon.spy()
    @trackMock = Ember.Object.create addPathPoint: sinon.spy()

    @drawController = Build.DrawController.create
      track: @trackMock
      stateManager: @buildScreenStateManagerMock

  afterEach ->
    @buildScreenStateManagerMock.restore()

  describe 'drawing by mouse move', ->

    it 'should add point to model if it has enough distance from last point', ->
      testPoint = x: 9999, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).toHaveBeenCalledWith testPoint

    it 'should not add point if it is too close to last added point', ->
      testPoint = x: 1, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).not.toHaveBeenCalled()

    it 'should not add further points when user finished drawing', ->
      @drawController.finishedDrawing = true

      testPoint = x: 0, y: 0
      @drawController.onTouchMouseMove testPoint

      (expect @trackMock.addPathPoint).not.toHaveBeenCalledWith testPoint

  describe 'finishing drawing', ->

    describe 'when track length is valid', ->

      beforeEach ->
        @trackMock.hasValidTotalLength = sinon.stub().returns true
        @trackMock.cleanPath = sinon.spy()

      it 'should clean the track on mouse up event', ->
        @drawController.onTouchMouseUp()

        (expect @trackMock.cleanPath).toHaveBeenCalled()

      it 'should signalize the end of drawing to the state manager', ->
        @drawController.onTouchMouseUp()

        (expect @buildScreenStateManagerMock.send).toHaveBeenCalledWith 'finishedDrawing'

    describe 'when track length is invalid', ->

      beforeEach ->
        @trackMock.hasValidTotalLength = sinon.stub().returns false
        @trackMock.clearPath = sinon.spy()

      it 'should tell the track model to clear path', ->
        @drawController.onTouchMouseUp()

        (expect @trackMock.clearPath).toHaveBeenCalled()
