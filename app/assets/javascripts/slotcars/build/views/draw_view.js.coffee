
#= require slotcars/shared/views/track_view
#= require slotcars/build/templates/draw_view_template
#= require helpers/event_normalize

PAPER_WRAPPER_ID = '#draw-view-paper'

(namespace 'slotcars.build.views').DrawView = slotcars.shared.views.TrackView.extend

  track: null
  drawController: null
  
  templateName: 'slotcars_build_templates_draw_view_template'
  elementId: 'build-draw-view'
  drawController: null

  _rasterizedTrackPath: null

  didInsertElement: ->
    @_paper = Raphael @$(PAPER_WRAPPER_ID)[0], 1024, 768

    @$(PAPER_WRAPPER_ID).on 'touchMouseDown', (event) => @_onTouchMouseDown(event)
    @$(PAPER_WRAPPER_ID).on 'touchMouseUp', (event) => @_onTouchMouseUp(event)

  onRasterizedPathChanged: (->
    # clean up before drawing anything
    @_rasterizedTrackPath.remove() if @_rasterizedTrackPath?
    @_rasterizedTrackPath = null

    # we can't draw if the track is null
    track = @get 'track'
    return unless track?

    # we can't draw the rasterized path if there is none
    rasterizedPath = (track.get 'rasterizedPath')
    if rasterizedPath
      @_rasterizedTrackPath = @_drawPath rasterizedPath, @ASPHALT_WIDTH, 'rgba(0, 255, 0, 0.5)'
  ).observes 'track.rasterizedPath'

  # overrides TrackView.drawTrack for specialized drawing in builder
  drawTrack: (path) ->
    return unless @_paper?

    if @drawController.get 'finishedDrawing'
      @_super path
    else
      @_drawTrackWhileDrawing path

  onClearButtonClicked: (event) ->
    event.preventDefault() if event?
    @drawController.onClearTrack()

  onPlayCreatedTrackButtonClicked: (event) ->
    event.preventDefault() if event?
    @drawController.onPlayCreatedTrack()

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

  _drawTrackWhileDrawing: (path) ->
    # remove the Z from path to not close it while drawing
    path = (path.substr 0, path.length - 1)
    @_paper.clear()
    # only draw the raw asphalt for better performance on iPad
    @_drawPath path, @BORDER_ASPHALT_WIDTH, @ASPHALT_COLOR
