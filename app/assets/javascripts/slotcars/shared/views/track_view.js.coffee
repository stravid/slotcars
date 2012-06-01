Shared.TrackView = Ember.View.extend

  track: null
  _displayedRaphaelElements: []
  _paper: null

  # configure which path layers NOT to draw
  # valid properties: 'dirt', 'outerLine', 'asphalt', 'medianStrip'
  excludedPathLayers: {}

  scaleFactor: 1

  DASHED_LINE_WIDTH: 3
  ASPHALT_WIDTH: 70
  BORDER_LINE_WIDTH: 75
  BORDER_ASPHALT_WIDTH: 81
  DIRT_WIDTH: 90

  ASPHALT_COLOR: '#1E1E1E'
  LINE_COLOR: '#FFF'
  DIRT_COLOR: '#A67B52'

  didInsertElement: ->
    @_paper = Raphael @$()[0], 1024 * @scaleFactor, 768 * @scaleFactor
    @drawTrack @track.get 'raphaelPath'

  onTrackChange: ( ->
    return unless @_paper?
    @updateTrack @track.get 'raphaelPath'
  ).observes 'track.raphaelPath'

  updateTrack: (path) ->
    (element.attr 'path', path) for element in @_displayedRaphaelElements

  drawTrack: (path) ->
    return unless @_paper?

    @_displayedRaphaelElements = []

    unless @excludedPathLayers.dirt
      @_drawPath path, @DIRT_WIDTH * @scaleFactor, @DIRT_COLOR

    unless @excludedPathLayers.asphalt
      @_drawPath path, @BORDER_ASPHALT_WIDTH * @scaleFactor, @ASPHALT_COLOR

    unless @excludedPathLayers.outerLine
      @_drawPath path, @BORDER_LINE_WIDTH * @scaleFactor, @LINE_COLOR
      @_drawPath path, @ASPHALT_WIDTH * @scaleFactor, @ASPHALT_COLOR

    unless @excludedPathLayers.medianStrip
      @_drawDashedLine path

  _drawPath: (path, width, color) ->
    path = @_paper.path path
    path.attr 'stroke', color
    path.attr 'stroke-width', width

    path.transform "s#{@scaleFactor},#{@scaleFactor},0,0"

    @_displayedRaphaelElements.push path

    path

  _drawDashedLine: (path) ->
    path = @_drawPath path, @DASHED_LINE_WIDTH * @scaleFactor, @LINE_COLOR
    path.attr 'stroke-dasharray', '- '
    path.attr 'stroke-linecap', 'square'

  destroy: ->
    @_super()
    @_paper.clear()
