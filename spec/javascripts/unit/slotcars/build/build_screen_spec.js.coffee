
#= require slotcars/build/build_screen
#= require slotcars/build/views/build_screen_view

describe 'build screen', ->

  BuildScreen = slotcars.build.BuildScreen

  it 'should mark itself as buildScreen for duck typing', ->
    buildScreen = BuildScreen.create()

    (expect buildScreen.isBuildScreen).toBe true

  describe 'integration with build screen state manager', ->

    beforeEach ->
      @BuildScreenStateManagerCreateStub = (sinon.stub slotcars.build.BuildScreenStateManager, 'create')

    afterEach -> @BuildScreenStateManagerCreateStub.restore()

    it 'should create state manager and register as delegate', ->
      buildScreen = BuildScreen.create()
      buildScreen.appendToApplication()

      (expect @BuildScreenStateManagerCreateStub).toHaveBeenCalledWithAnObjectLike delegate: buildScreen


  describe 'appending the screen', ->

    beforeEach ->
      @buildScreenViewCreateStub = (sinon.stub slotcars.build.views.BuildScreenView, 'create')

      @buildScreenViewAppendMethodStub = sinon.spy()

      @buildScreenViewCreateStub.returns
        append: @buildScreenViewAppendMethodStub

      @buildScreen = BuildScreen.create()

    afterEach ->
      @buildScreenViewCreateStub.restore()

    it 'should append the build screen view to the DOM body', ->
      @buildScreen.appendScreen()

      (expect @buildScreenViewAppendMethodStub).toHaveBeenCalled()

    it 'should provide itself as delegate to the build screen view', ->
      @buildScreen.appendScreen()

      (expect @buildScreenViewCreateStub).toHaveBeenCalledWithAnObjectLike delegate: @buildScreen
