
#= require slotcars/shared/views/track_view
#= require slotcars/build/templates/rasterization_view_template

TrackView = slotcars.shared.views.TrackView

(namespace 'Slotcars.build.views').RasterizationView = TrackView.extend
  
  templateName: 'slotcars_build_templates_rasterization_view_template'
  track: null

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
