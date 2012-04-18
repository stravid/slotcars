describe 'rasterization view', ->

  TrackView = slotcars.shared.views.TrackView

  it 'should extend TrackView', ->
    (expect Build.RasterizationView).toExtend TrackView
