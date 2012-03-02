
#= require slotcars/build/build_screen_state_manager

describe 'build screen state management', ->

  BuildScreenStateManager = slotcars.build.BuildScreenStateManager

  beforeEach ->
    @buildScreenStub =
      initialize: sinon.stub()

    @buildScreenStateManager = BuildScreenStateManager.create
      delegate: @buildScreenStub

  it 'should tell the build screen to initialize in default state', ->
    (expect @buildScreenStub.initialize).toHaveBeenCalled()

  it 'should tell the build screen to start drawing after initializing', ->
    @buildScreenStub.startDrawing = sinon.stub()
    @buildScreenStateManager.send 'initialized'

    (expect @buildScreenStub.startDrawing).toHaveBeenCalled()
