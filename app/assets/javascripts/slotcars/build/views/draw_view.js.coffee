
#= require slotcars/shared/views/track_view

PAPER_WRAPPER_ID = '#draw-view-paper'

Build.DrawView = Shared.TrackView.extend

  track: null

  templateName: 'slotcars_build_templates_draw_view_template'
  elementId: 'build-draw-view'
  drawController: null

  _rasterizedTrackPath: null

  didInsertElement: ->
    @_paper = Raphael @$(PAPER_WRAPPER_ID)[0], 1024, 768

    @$(PAPER_WRAPPER_ID).on 'touchMouseDown', (event) => @_onTouchMouseDown(event)
    @$(PAPER_WRAPPER_ID).on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

    @drawTrack @track.get 'raphaelPath'

  # overrides TrackView.drawTrack for specialized drawing in builder
  drawTrack: (path) ->
    return unless @_paper?
    @_paper.clear()
    # only draw the raw asphalt for better performance on iPad
    @_drawPath path, @BORDER_ASPHALT_WIDTH, @ASPHALT_COLOR

  updateTrack: (path) ->
    # remove the Z from path to not close it while drawing
    path = (path.substr 0, path.length - 1)
    @_super path

  willDestroyElement: ->
    @$(PAPER_WRAPPER_ID).off 'touchMouseDown'
    @$(PAPER_WRAPPER_ID).off 'touchMouseUp'

  _onTouchMouseDown: (event) ->
    event.stopPropagation()
    @$('#draw-info').animate opacity: 0
    @$(PAPER_WRAPPER_ID).on 'touchMouseMove', (event) => @_onTouchMouseMove(event)

  _onTouchMouseMove: (event) ->
    event.stopPropagation()
    event.originalEvent.preventDefault() if event.originalEvent?
    offset = @$().offset()
    @drawController.onTouchMouseMove x: event.pageX - offset.left, y: event.pageY - offset.top

  _onTouchMouseUp: (event) ->
    event.stopPropagation()
    @$(PAPER_WRAPPER_ID).off 'touchMouseMove'
    @drawController.onTouchMouseUp()
