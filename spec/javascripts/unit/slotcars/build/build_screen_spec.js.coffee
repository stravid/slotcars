
#= require slotcars/build/build_screen
#= require slotcars/build/views/build_screen_view
#= require slotcars/build/builder

describe 'slotcars.build.BuildScreen', ->

  BuildScreen = slotcars.build.BuildScreen
  BuilderController = slotcars.build.Builder
  BuilderScreenView = slotcars.build.views.BuildScreenView

  beforeEach ->
    @buildScreenViewMock = mockEmberClass BuilderScreenView,
      append: sinon.spy()
      remove: sinon.spy()

    @builderControllerMock = mockEmberClass BuilderController
    @buildScreen = BuildScreen.create()

  afterEach ->
    @buildScreenViewMock.restore()
    @builderControllerMock.restore()

  describe 'append to application', ->

    beforeEach ->
      @buildScreen.appendView = sinon.spy()

    it 'should call appendView method on itself', ->
      @buildScreen.appendToApplication()

      (expect @buildScreen.appendView).toHaveBeenCalled()

    it 'should create builder and provide build screen view', ->
      @buildScreen.appendToApplication()

      (expect @builderControllerMock.create).toHaveBeenCalledWithAnObjectLike buildScreenView: @buildScreenViewMock


  describe 'destroy', ->

    beforeEach ->
      @builderControllerMock.destroy = sinon.spy()
      @buildScreen.appendToApplication()

    it 'should tell the builder to destroy itself', ->
      @buildScreen.destroy()

      (expect @builderControllerMock.destroy).toHaveBeenCalled()