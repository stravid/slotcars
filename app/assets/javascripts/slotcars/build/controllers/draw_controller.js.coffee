
#= require helpers/namespace

namespace 'slotcars.build.controllers'

slotcars.build.controllers.DrawController = Ember.Object.extend

  track: null
  finishedDrawing: false

  onTouchMouseMove: (point) -> @track.addPathPoint point unless @finishedDrawing

  onClearTrack: ->
    @finishedDrawing = false
    @track.clearPath()

  onTouchMouseUp: ->
    @finishedDrawing = true
    @track.cleanPath()