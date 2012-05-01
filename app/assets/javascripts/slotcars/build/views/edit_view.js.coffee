Build.EditView = Shared.TrackView.extend

  circles: null

  drawTrack: (path) ->
    return unless @_paper?
    @_super path

    @pathPoints = @track.getPathPoints() unless @pathPoints?
    @_drawEditingHandles()

  _drawEditingHandles: ->
    @circles = @_paper.set()

    for point, i in @pathPoints
      circle = @_paper.circle point.x, point.y, 24
      circle.attr stroke: '#000000', 'stroke-width': 3
      circle.attr 'fill', '#00a2bf' # Raphael.getColor()
      @circles.push circle

    @circles.drag @_onEditHandleMove, @_onEditHandleDragStart

  _onEditHandleDragStart: (x, y, event) ->
    @dx = @dy = 0

  _onEditHandleMove: (dx, dy, x, y, event) ->
    X = (@attr 'cx') + (dx - (@dx || 0))
    Y = (@attr 'cy') + (dy - (@dy || 0))
    @attr cx: X, cy: Y

    @dx = dx

