
#= require helpers/namespace
#= require slotcars/shared/views/track_view
#= require helpers/event_normalize

namespace 'slotcars.build.views'

slotcars.build.views.DrawView = slotcars.shared.views.TrackView.extend

  elementId: 'build-draw-view'
  drawController: null
  trackBinding: 'drawController.track'

  didInsertElement: ->
    @_super()
    @$().on 'touchMouseMove', (event) => @_onTouchMouseMove(event)
    @$().on 'touchMouseDown', (event) => @drawController.onTouchMouseDown()
    @$().on 'touchMouseUp', (event) => @drawController.onTouchMouseUp()

  onRaphaelPathChanged: (->
    @drawTrack (@get 'track').get 'raphaelPath' if (@get 'track')?
  ).observes 'track.raphaelPath'

  drawTrack: (path) ->
    # remove the Z from path to not close it while drawing
    path = (path.substr 0, path.length - 1) if @isDrawing

    @_super path

  _onTouchMouseMove: (event) ->
    @drawController.onTouchMouseMove x: event.pageX, y: event.pageY

  willDestroyElement: ->
    @$().off 'touchMouseMove'
    @$().off 'touchMouseDown'
    @$().off 'touchMouseUp'