
#= require slotcars/build/build_screen_state_manager

describe 'build screen state manager', ->

  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  beforeEach ->
    @delegateMock =
      setupDrawing: sinon.spy()
      teardownDrawing: sinon.spy()
      setupTesting: sinon.spy()
      teardownTesting: sinon.spy()

  it 'should extend Ember.StateManager', ->
    (expect BuildScreenStateManager).toExtend Ember.StateManager

  describe 'drawing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Drawing'

    it 'should prepare drawing environment on entering the state', ->
      (expect @delegateMock.setupDrawing).toHaveBeenCalled()

    it 'should tear drawing environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownDrawing).toHaveBeenCalled()

  describe 'testing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Testing'

    it 'should prepare test-drive-environment on entering the state', ->
      (expect @delegateMock.setupTesting).toHaveBeenCalled()

    it 'should tear test-drive-environment down on leavin the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownTesting).toHaveBeenCalled()
