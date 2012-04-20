ADD_POINT_MIN_DISTANCE = 30

Build.DrawController = Ember.Object.extend

  track: null
  _lastAddedPoint: null

  onTouchMouseMove: (point) ->
    # only add new point if it is at least 40 pixels away from last
    @_lastAddedPoint = { x: 0, y: 0 } unless @_lastAddedPoint?
    distanceVector = Shared.Vector.create from: @_lastAddedPoint, to: point
    @addPointToTrack point if distanceVector.length() > ADD_POINT_MIN_DISTANCE

  addPointToTrack: (point) ->
    @track.addPathPoint point
    @_lastAddedPoint = point

  onTouchMouseUp: ->
    if @track.hasValidTotalLength()
      @track.cleanPath()
      @stateManager.send 'finishedDrawing'
    else
      @track.clearPath()
