
#= require slotcars/build/build_screen_state_manager

describe 'build screen state manager', ->

  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  beforeEach ->
    @delegateMock =
      prepareDrawing: sinon.spy()
      teardownDrawing: sinon.spy()
      prepareTesting: sinon.spy()
      teardownTesting: sinon.spy()

  it 'should extend Ember.StateManager', ->
    (expect BuildScreenStateManager).toExtend Ember.StateManager

  it 'should go drawing state by default', ->
    buildScreenStateManager = BuildScreenStateManager.create
      delegate: @delegateMock

    (expect buildScreenStateManager.currentState.name).toEqual 'Drawing'

  describe 'drawing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

    it 'should prepare drawing environment on entering the state', ->
      (expect @delegateMock.prepareDrawing).toHaveBeenCalled()

    it 'should tear drawing environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownDrawing).toHaveBeenCalled()

  describe 'testing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Testing'

    it 'should prepare test-drive-environment on entering the state', ->
      (expect @delegateMock.prepareTesting).toHaveBeenCalled()

    it 'should tear test-drive-environment down on leavin the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownTesting).toHaveBeenCalled()
