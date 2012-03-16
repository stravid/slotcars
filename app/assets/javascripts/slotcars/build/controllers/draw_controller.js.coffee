
#= require helpers/namespace

namespace 'slotcars.build.controllers'

slotcars.build.controllers.DrawController = Ember.Object.extend

  track: null
  finishedDrawing: false
  isRasterizing: false

  onTouchMouseMove: (point) -> @track.addPathPoint point unless @finishedDrawing

  onClearTrack: ->
    @set 'finishedDrawing', false
    @_cancelRasterization() if @get 'isRasterizing'
    @track.clearPath()

  onTouchMouseUp: ->
    @set 'finishedDrawing', true
    @track.cleanPath()

  onPlayCreatedTrack: ->
    @set 'isRasterizing', true
    @track.rasterize =>
      slotcars.routeManager.set 'location', @track.get 'playRoute'

  _cancelRasterization: ->
    @set 'isRasterizing', false
    @track.cancelRasterization()
