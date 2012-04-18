describe 'rasterization view', ->

  TrackView = slotcars.shared.views.TrackView
  RasterizationView = Slotcars.build.views.RasterizationView

  it 'should extend TrackView', ->
    (expect RasterizationView).toExtend TrackView
