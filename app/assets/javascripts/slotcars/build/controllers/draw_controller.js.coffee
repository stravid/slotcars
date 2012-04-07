
#= require helpers/math/vector

ADD_POINT_MIN_DISTANCE = 30

(namespace 'slotcars.build.controllers').DrawController = Ember.Object.extend

  track: null
  finishedDrawing: false
  isRasterizing: false
  _lastAddedPoint: null

  onTouchMouseMove: (point) ->
    return if @finishedDrawing
    # only add new point if it is at least 40 pixels away from last
    @_lastAddedPoint = { x: 0, y: 0 } unless @_lastAddedPoint?
    distanceVector = helpers.math.Vector.create from: @_lastAddedPoint, to: point
    @addPointToTrack point if distanceVector.length() > ADD_POINT_MIN_DISTANCE

  addPointToTrack: (point) ->
    @track.addPathPoint point
    @_lastAddedPoint = point

  onClearTrack: ->
    @set 'finishedDrawing', false
    @_cancelRasterization() if @get 'isRasterizing'
    @track.clearPath()

  onTouchMouseUp: ->
    @set 'finishedDrawing', true
    @track.cleanPath()

  onPlayCreatedTrack: ->
    # don't start multiple rasterizations
    return if @get 'isRasterizing'
    # only play track when it was created first
    return unless @get 'finishedDrawing'

    @set 'isRasterizing', true
    @track.rasterize => @_finishedRasterization()

  _cancelRasterization: ->
    @set 'isRasterizing', false
    @track.cancelRasterization()

  _finishedRasterization: ->
    @set 'isRasterizing', false
    @stateManager.goToState 'Testing'
