
#= require helpers/namespace
#= require vendor/raphael

namespace 'slotcars.shared.views'

slotcars.shared.views.TrackView = Ember.View.extend

  elementId: 'track-view'
  gameController: null
  _paper: null
  _path: null

  DASHED_LINE_WIDTH: 3
  ASPHALT_WIDTH: 70
  BORDER_LINE_WIDTH: 75
  BORDER_ASPHALT_WIDTH: 81
  DIRT_WIDTH: 90
  
  ASPHALT_COLOR: '#1E1E1E'
  LINE_COLOR: '#FFF'
  DIRT_COLOR: '#A67B52'

  didInsertElement: ->
    @_paper = Raphael @$()[0], 1024, 768
    @drawTrack @_path

  drawTrack: (path) ->
    # save path when not in DOM to draw it as soon as inserted
    unless @_paper?
      @_path = path
      return

    @_paper.clear()

    @_drawPath path, @DIRT_WIDTH, @DIRT_COLOR
    @_drawPath path, @BORDER_ASPHALT_WIDTH, @ASPHALT_COLOR
    @_drawPath path, @BORDER_LINE_WIDTH, @LINE_COLOR
    @_drawPath path, @ASPHALT_WIDTH, @ASPHALT_COLOR
    @_drawDashedLine path
  
  onCarControlsChange: (->
    (jQuery document).off 'touchMouseDown'
    (jQuery document).off 'touchMouseUp'

    if @gameController.get 'carControlsEnabled'
      (jQuery document).on 'touchMouseDown', (event) => @gameController.onTouchMouseDown event
      (jQuery document).on 'touchMouseUp', (event) => @gameController.onTouchMouseUp event

  ).observes 'gameController.carControlsEnabled'

  _drawPath: (path, width, color) ->
    path = @_paper.path path;
    path.attr 'stroke', color
    path.attr 'stroke-width', width
    
    path
  
  _drawDashedLine: (path) ->
    path = @_drawPath path, @DASHED_LINE_WIDTH, @LINE_COLOR
    path.attr 'stroke-dasharray', '- '
    path.attr 'stroke-linecap', 'square'