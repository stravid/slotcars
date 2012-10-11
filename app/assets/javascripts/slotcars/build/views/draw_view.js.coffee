#= require slotcars/shared/views/track_view

Build.DrawView = Shared.TrackView.extend

  track: null

  templateName: 'slotcars_build_templates_draw_view_template'
  elementId: 'build-draw-view'
  drawController: null

  didInsertElement: ->
    @_super()
    @$().on 'touchMouseDown', (event) => @_onTouchMouseDown(event)
    @$().on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  # overrides TrackView.drawTrack for specialized rendering in draw mode
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
    @$().off 'touchMouseDown'
    @$().off 'touchMouseUp'

  _onTouchMouseDown: (event) ->
    event.stopPropagation()
    @$('#draw-info').animate opacity: 0
    @$().on 'touchMouseMove', (event) => @_onTouchMouseMove(event)

  _onTouchMouseMove: (event) ->
    event.stopPropagation()
    event.originalEvent.preventDefault() if event.originalEvent?
    offset = @$().offset()
    @drawController.onTouchMouseMove x: event.pageX - offset.left, y: event.pageY - offset.top

  _onTouchMouseUp: (event) ->
    event.stopPropagation()
    @$().off 'touchMouseMove'
    @drawController.onTouchMouseUp()
