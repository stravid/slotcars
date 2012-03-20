
#= require vendor/raphael

Vector = helpers.math.Vector

(namespace 'slotcars.shared.views').TrackView = Ember.View.extend

  elementId: 'track-view'
  track: null
  
  _paper: null

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

  onTrackChange: ( -> 
    return unless @track?
    @drawTrack @track.get 'raphaelPath'
  ).observes 'track.raphaelPath'

  drawTrack: (path) ->
    return unless @_paper?

    @_paper.clear()

    @_drawPath path, @DIRT_WIDTH, @DIRT_COLOR
    @_drawPath path, @BORDER_ASPHALT_WIDTH, @ASPHALT_COLOR
    @_drawPath path, @BORDER_LINE_WIDTH, @LINE_COLOR
    @_drawPath path, @ASPHALT_WIDTH, @ASPHALT_COLOR
    @_drawDashedLine path

  _drawPath: (path, width, color) ->
    path = @_paper.path path;
    path.attr 'stroke', color
    path.attr 'stroke-width', width
    
    path
  
  _drawDashedLine: (path) ->
    path = @_drawPath path, @DASHED_LINE_WIDTH, @LINE_COLOR
    path.attr 'stroke-dasharray', '- '
    path.attr 'stroke-linecap', 'square'