
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

  drawTrack: ->
    return unless @track?

    @path = @track.get 'raphaelPath'

    # remove the Z from path to not close it while drawing
    @path = @path.substr 0, @path.length - 1

    @_drawLawn()
    @_drawOutterBase()
    @_drawOutterDash()
    @_drawOutterAsphalt()
    @_drawSideLine()
    @_drawAsphalt()
    @_drawDashedLine()

  willDestroyElement: -> @$().off 'touchMouseMove'