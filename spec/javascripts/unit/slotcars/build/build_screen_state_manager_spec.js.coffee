
#= require slotcars/build/build_screen_state_manager

describe 'build screen state management', ->

  BuildScreenStateManager = slotcars.build.BuildScreenStateManager

  beforeEach ->
    @buildScreenStub =
      appendScreen: sinon.stub()
      removeScreen: sinon.stub()

    @buildScreenStateManager = BuildScreenStateManager.create
      delegate: @buildScreenStub

  describe 'actions sent by the composite building state', ->

    it 'should tell the build screen to append itself to the DOM when entered', ->
      (expect @buildScreenStub.appendScreen).toHaveBeenCalled()

    it 'should tell the build screen to remove itself from the DOM when exited', ->
      @buildScreenStateManager.send 'destroy'

      (expect @buildScreenStub.removeScreen).toHaveBeenCalled()
