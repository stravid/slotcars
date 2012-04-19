describe 'rasterization view', ->

  it 'should extend TrackView', ->
    (expect Build.RasterizationView).toExtend Shared.TrackView
