
#= require slotcars/build/build_screen
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder

describe 'slotcars.build.BuildScreen', ->

  BuildScreen = slotcars.build.BuildScreen
  BuilderController = slotcars.build.Builder
  BuildScreenView = slotcars.build.views.BuildScreenView

  beforeEach ->
    @buildScreenViewMock = mockEmberClass BuildScreenView,
      append: sinon.spy()
      remove: sinon.spy()

    @builderControllerMock = mockEmberClass BuilderController
    @buildScreen = BuildScreen.create()

  afterEach ->
    @buildScreenViewMock.restore()
    @builderControllerMock.restore()

  it 'should create build screen view', ->
    (expect @buildScreenViewMock.create).toHaveBeenCalled()

  it 'should create builder and provide build screen view', ->
    (expect @builderControllerMock.create).toHaveBeenCalledWithAnObjectLike buildScreenView: @buildScreenViewMock

  describe 'destroy', ->

    beforeEach ->
      @builderControllerMock.destroy = sinon.spy()

    it 'should tell the builder to destroy itself', ->
      @buildScreen.destroy()

      (expect @builderControllerMock.destroy).toHaveBeenCalled()