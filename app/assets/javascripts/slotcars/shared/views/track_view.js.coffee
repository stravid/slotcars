#= require vendor/canvg/rgbcolor
#= require vendor/canvg/canvg

Shared.TrackView = Ember.View.extend

  track: null
  _displayedRaphaelElements: []
  _paper: null

  # configure which path layers NOT to draw
  # valid properties: 'dirt', 'outerLine', 'asphalt', 'slot'
  excludedPathLayers: {}

  scaleFactor: 1

  SLOT_WIDTH: 3
  SLOT_EDGE_WIDTH: 8

  ASPHALT_WIDTH: 70
  BORDER_LINE_WIDTH: 75
  BORDER_ASPHALT_WIDTH: 81
  DIRT_WIDTH: 90

  ASPHALT_COLOR: '#1E1E1E'
  LINE_COLOR: '#FFF'
  SLOT_EDGE_COLOR: '#777'
  SLOT_COLOR: '#000'
  DIRT_COLOR: '#A67B52'

  onTrackChange: ( ->
    return unless @_paper?
    @updateTrack @track.get 'raphaelPath'
  ).observes 'track.raphaelPath'

  didInsertElement: ->
    @_paper = Raphael @$()[0], SCREEN_WIDTH * @scaleFactor, SCREEN_HEIGHT * @scaleFactor
    @drawTrack @track.get 'raphaelPath'

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

    unless @excludedPathLayers.slot
      @_drawSlot path

  _drawPath: (path, width, color) ->
    path = @_paper.path path
    path.attr 'stroke', color
    path.attr 'stroke-width', width

    path.transform "s#{@scaleFactor},#{@scaleFactor},0,0"

    @_displayedRaphaelElements.push path

    path

  _drawSlot: (path) ->
    slotEdge = @_drawPath path, @SLOT_EDGE_WIDTH * @scaleFactor, @SLOT_EDGE_COLOR
    slot = @_drawPath path, @SLOT_WIDTH * @scaleFactor, @SLOT_COLOR

  destroy: ->
    @_paper.remove() if @_paper?
    @_super()
