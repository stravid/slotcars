
#= require slotcars/shared/views/track_view

Build.RasterizationView = Shared.TrackView.extend
  
  templateName: 'slotcars_build_templates_rasterization_view_template'
  track: null

  excludedPathLayers: outerLine: true, slot: true
  _displayedOverlayPaths: []

  drawTrack: (path) ->
    @_super path

    @_drawTrackOverlay (@get 'track').get 'rasterizedPath'

  onRasterizedPathChanged: (->
    rasterizedPath = (@get 'track').get 'rasterizedPath'
    (element.attr 'path', rasterizedPath) for element in @_displayedOverlayPaths
  ).observes 'track.rasterizedPath'

  _drawTrackOverlay: (rasterizedPath) ->
    @_displayedOverlayPaths = []

    @_displayedOverlayPaths.push @_drawPath rasterizedPath, @BORDER_ASPHALT_WIDTH, @ASPHALT_COLOR
    @_displayedOverlayPaths.push @_drawPath rasterizedPath, @BORDER_LINE_WIDTH, @LINE_COLOR
    @_displayedOverlayPaths.push @_drawPath rasterizedPath, @ASPHALT_WIDTH, @ASPHALT_COLOR
    @_displayedOverlayPaths.push @_drawSlot rasterizedPath
