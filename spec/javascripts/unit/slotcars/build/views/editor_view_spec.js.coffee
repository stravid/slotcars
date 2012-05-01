describe 'Build.EditView', ->

  beforeEach ->
    @trackMock = mockEmberClass Shared.Track,
      getPathPoints: sinon.stub().returns [{x: 0, y: 0}, {x: 10, y: 10}, {x: 20, y: 5}]
      updateRaphaelPath: sinon.spy()

    @editView = Build.EditView.create
      track: @trackMock

  afterEach ->
    @trackMock.restore()

  it 'should extend TrackView', ->
    (expect Build.EditView).toExtend Shared.TrackView

  describe 'drawing handles (circles)', ->

    beforeEach ->
      @raphaelPathString = 'M0,0R10,10,20,5z'

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
      @editView.drawTrack @raphaelPathString

      (expect @trackMock.getPathPoints).toHaveBeenCalled()

    it 'should draw circles for each point of the raphael path', ->
      @editView.drawTrack @raphaelPathString

      (expect @circleElementStub).toHaveBeenCalledThrice()  # path has 3 points -> call 3 times
      (expect @pushCircleSpy).toHaveBeenCalledThrice()      # path has 3 points -> call 3 times

    it 'should bind drag event to all circles', ->
      @editView.drawTrack @raphaelPathString

      (expect @editView.circles.drag).toHaveBeenCalled()

  describe 'updating track', ->

    beforeEach ->
      @editView.pathPoints = [] # normally set in drawTrack

    it 'should update the moved point in the path points array', ->
      index = 2
      point = x: 78, y: 13

      @editView.updateTrack index, point

      (expect @editView.pathPoints[index]).toBe point

    it 'should update the track´s path with the current path points', ->
      index = 2
      point = x: 78, y: 13

      @editView.updateTrack index, point

      (expect @trackMock.updateRaphaelPath).toHaveBeenCalled()
