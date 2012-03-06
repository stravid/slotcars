
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

  onRaphaelPathChanged: (->
    @drawTrack()
  ).observes 'track.raphaelPath'

  _onTouchMouseMove: (event) ->
    @drawController.onTouchMouseMove x: event.pageX, y: event.pageY