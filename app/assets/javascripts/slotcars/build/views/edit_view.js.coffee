Build.EditView = Shared.TrackView.extend

  circles: null

  drawTrack: (path) ->
    @_super path

    @pathPoints = @track.getPathPoints() unless @pathPoints?
    @_drawEditingHandles()

  _drawEditingHandles: ->
    @circles = @_paper.set()

    for point, i in @pathPoints
      circle = @_paper.circle point.x, point.y, 34
      circle.attr stroke: '#000000', 'stroke-width': 3
      circle.attr 'fill', '#00d0f5'
      circle.data 'index', i
      @circles.push circle

    @circles.data 'viewContext', this
    @circles.drag @_onEditHandleMove, @_onEditHandleDragStart

  _onEditHandleDragStart: (x, y, event) ->
    @deltaX = @deltaY = 0

  _onEditHandleMove: (deltaX, deltaY, x, y, event) ->
    X = (@attr 'cx') + (deltaX - @deltaX)
    Y = (@attr 'cy') + (deltaY - @deltaY)
    @attr cx: X, cy: Y

    @deltaX = deltaX
    @deltaY = deltaY

    (@data 'viewContext')._updatePathPoint (@data 'index'), { x: X, y: Y }

  _updatePathPoint: (index, newPoint) ->
    @pathPoints[index] = newPoint
    @track.updateRaphaelPath @pathPoints
