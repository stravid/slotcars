
#= require slotcars/build/views/rasterization_view
#= require slotcars/build/rasterizer

describe 'rasterization view', ->

  TrackView = slotcars.shared.views.TrackView
  Rasterizer = Slotcars.build.Rasterizer
  RasterizationView = Slotcars.build.views.RasterizationView

  beforeEach ->
    @trackMock = {}

    @rasterizerMock = mockEmberClass Rasterizer, cancel: sinon.spy()

    @rasterizationView = RasterizationView.create
      rasterizationController: @rasterizerMock
      track: @trackMock

  afterEach ->
    @rasterizerMock.restore()

  it 'should extend TrackView', ->
    (expect RasterizationView).toExtend TrackView

  describe 'clicking on cancel button', ->

    it 'should tell controller to cancel the rasterization', ->
      @rasterizationView.onCancelButtonClicked()

      (expect @rasterizerMock.cancel).toHaveBeenCalled()
