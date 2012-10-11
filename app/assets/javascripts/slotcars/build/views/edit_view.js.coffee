Build.EditView = Shared.TrackView.extend

  templateName: 'slotcars_build_templates_edit_view_template'

  circles: null
  excludedPathLayers: outerLine: true, slot: true
  boundaries:
    minimum: x: 0, y: 100
    maximum: x: SCREEN_WIDTH, y: SCREEN_HEIGHT

  drawTrack: (path) ->
    @_super path
    @pathPoints = @track.getPathPoints() unless @pathPoints?
    @_drawEditingHandles()

  _drawEditingHandles: ->
    @circles = @_paper.set()

    for point, i in @pathPoints
      circle = @_paper.circle point.x, point.y, 34
      circle.attr stroke: '#385A6A', 'stroke-width': 2
      circle.attr 'fill', '#6CACCA'
      circle.data 'index', i
      @circles.push circle

    @circles.data 'viewContext', this
    @circles.drag @_onEditHandleMove, @_onEditHandleDragStart, @_onEditHandleDragEnd
    @circles.transform "t#{@scaledOffset},#{@scaledOffset}"

  _onEditHandleDragEnd: (x, y, event) ->
    @animate { r: 34, opacity: 1 }, 300, 'bounce'

  _onEditHandleDragStart: (x, y, event) ->
    @deltaX = @deltaY = 0
    @animate { r: 49, opacity: .7 }, 300, '<'

  _onEditHandleMove: (deltaX, deltaY, x, y, event) ->
    x = (@attr 'cx') + (deltaX - @deltaX)
    y = (@attr 'cy') + (deltaY - @deltaY)

    boundaries = (@data 'viewContext').boundaries

    if      x < boundaries.minimum.x then x = boundaries.minimum.x
    else if x > boundaries.maximum.x then x = boundaries.maximum.x
    else  @deltaX = deltaX

    if      y < boundaries.minimum.y then y = boundaries.minimum.y
    else if y > boundaries.maximum.y then y = boundaries.maximum.y
    else    @deltaY = deltaY

    @attr cx: x, cy: y

    (@data 'viewContext').updatePathPoint (@data 'index'), { x: x, y: y }

  updatePathPoint: (index, newPoint) ->
    @pathPoints[index] = newPoint
    @track.updateRaphaelPath @pathPoints

    Ember.run.sync() # reduces sluggishness while dragging
