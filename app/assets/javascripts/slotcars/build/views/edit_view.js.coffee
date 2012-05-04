Build.EditView = Shared.TrackView.extend

  circles: null
  excludedPathLayers: outerLine: true, medianStrip: true

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
    @circles.drag @_onEditHandleMove, @_onEditHandleDragStart, @_onEditHandleDragEnd

  _onEditHandleDragEnd: (x, y, event) ->
    @animate { r: 34, opacity: 1 }, 300, 'bounce'

  _onEditHandleDragStart: (x, y, event) ->
    @deltaX = @deltaY = 0
    @animate { r: 49, opacity: .7 }, 300, '<'

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

    Ember.run.sync() # reduces sluggishness while dragging
