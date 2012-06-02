describe 'Build.EditView', ->

  beforeEach ->
    @fakePathPointsArray = [ {x: 0, y: 0}, {x: 1, y: 0}, {x: 0, y: 1} ]
    @fakeRaphaelPath = 'M0,0R1,0,0,1z'

    @trackMock = mockEmberClass Shared.Track,
      getPathPoints: sinon.stub().returns @fakePathPointsArray
      get: sinon.stub().withArgs('raphaelPath').returns @fakeRaphaelPath
      updateRaphaelPath: sinon.spy()

    @editView = Build.EditView.create
      track: @trackMock

  afterEach ->
    @trackMock.restore()

  it 'should extend TrackView', ->
    (expect Build.EditView).toExtend Shared.TrackView

  describe 'drawing handles (circles)', ->

    beforeEach ->
      @pushCircleSpy = sinon.spy()
      @paperElementStub = sinon.stub().returns
        attr: ->
        transform: ->
        data: ->
        drag: sinon.spy()
        push: @pushCircleSpy
      @circleElementStub = sinon.stub().returns
        attr: ->
        data: ->

      @raphaelBackup = window.Raphael
      @raphaelStub = window.Raphael = sinon.stub().returns
        path: @paperElementStub
        set: @paperElementStub
        circle: @circleElementStub
        clear: sinon.spy()

      # normally caused by inserting view -
      # but inserting automatically invokes drawTrack so call counts wouldn´t be correct
      @editView._paper = Raphael()

    afterEach ->
      window.Raphael = @raphaelBackup

    it 'should fetch all path points as an array', ->
      @editView.drawTrack @fakeRaphaelPath

      (expect @trackMock.getPathPoints).toHaveBeenCalled()

    it 'should draw circles for each point of the raphael path', ->
      @editView.drawTrack @fakeRaphaelPath

      (expect @circleElementStub).toHaveBeenCalledThrice()  # path has 3 points -> call 3 times
      (expect @pushCircleSpy).toHaveBeenCalledThrice()      # path has 3 points -> call 3 times

    it 'should bind drag event to all circles', ->
      @editView.drawTrack @fakeRaphaelPath

      (expect @editView.circles.drag).toHaveBeenCalled()

  describe 'updating path points', ->

    beforeEach ->
      Ember.run => @editView.appendTo jQuery '<div>'

      @fakePathPoint = x: 1, y: 1
      @indexOfDragHandle = 0

    it 'should update the position of the moved drag-handle in the path points array', ->
      # simulates succesful dragging - using real events does not work in headless browsers
      @editView.updatePathPoint @indexOfDragHandle, @fakePathPoint

      (expect @editView.pathPoints[@indexOfDragHandle]).toEqual @fakePathPoint

    it 'should update the track´s path with the current path points', ->
      # simulates succesful dragging - using real events does not work in headless browsers
      @editView.updatePathPoint @indexOfDragHandle, @fakePathPoint

      (expect @trackMock.updateRaphaelPath).toHaveBeenCalled()
