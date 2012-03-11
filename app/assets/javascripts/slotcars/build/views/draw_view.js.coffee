
#= require helpers/namespace
#= require slotcars/shared/views/track_view
#= require slotcars/build/templates/draw_view_template
#= require helpers/event_normalize

namespace 'slotcars.build.views'

PAPER_WRAPPER_ID = '#draw-view-paper'

slotcars.build.views.DrawView = slotcars.shared.views.TrackView.extend

  templateName: 'slotcars_build_templates_draw_view_template'
  elementId: 'build-draw-view'
  drawController: null
  trackBinding: 'drawController.track'

  didInsertElement: ->
    @_paper = Raphael @$(PAPER_WRAPPER_ID)[0], 1024, 768

    @$(PAPER_WRAPPER_ID).on 'touchMouseDown', (event) => @_onTouchMouseDown(event)
    @$(PAPER_WRAPPER_ID).on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  onRaphaelPathChanged: (->
    track = @get 'track'
    @drawTrack track.get 'raphaelPath' if track?
  ).observes 'track.raphaelPath'

  # overrides TrackView.drawTrack for drawing
  drawTrack: (path) ->
    # remove the Z from path to not close it while drawing
    path = (path.substr 0, path.length - 1) unless @drawController.get 'finishedDrawing'

    @_super path

  onClearButtonClicked: (event) ->
    event.preventDefault() if event?
    @drawController.onClearTrack()

  willDestroyElement: ->
    @$(PAPER_WRAPPER_ID).off 'touchMouseDown'
    @$(PAPER_WRAPPER_ID).off 'touchMouseUp'

  _onTouchMouseDown: ->
    @$(PAPER_WRAPPER_ID).on 'touchMouseMove', (event) => @_onTouchMouseMove(event)

  _onTouchMouseMove: (event) ->
    event.originalEvent.preventDefault() if event.originalEvent?
    @drawController.onTouchMouseMove x: event.pageX, y: event.pageY

  _onTouchMouseUp: ->
    @$(PAPER_WRAPPER_ID).off 'touchMouseMove'
    @drawController.onTouchMouseUp()