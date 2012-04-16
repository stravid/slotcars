
#= require slotcars/build/build_screen_state_manager

describe 'build screen state manager', ->

  BuildScreenStateManager = Slotcars.build.BuildScreenStateManager

  beforeEach ->
    @delegateMock =
      setupDrawing: sinon.spy()
      teardownDrawing: sinon.spy()
      setupTesting: sinon.spy()
      teardownTesting: sinon.spy()
      setupRasterizing: sinon.spy()
      startRasterizing: sinon.spy()
      teardownRasterizing: sinon.spy()

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

    it 'should go to Editing state when finishedDrawing action was triggered', ->
      sinon.spy @buildScreenStateManager, 'goToState'
      @buildScreenStateManager.send 'finishedDrawing'

      (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Editing'


  describe 'testing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Testing'

    it 'should prepare test drive environment on entering the state', ->
      (expect @delegateMock.setupTesting).toHaveBeenCalled()

    it 'should tear test drive environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownTesting).toHaveBeenCalled()

    describe 'clicked redraw button', ->

      it 'should go to state Drawing', ->
        sinon.spy @buildScreenStateManager, 'goToState'
        @buildScreenStateManager.send 'clickedDrawButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalled 'Drawing'


  describe 'editing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Editing'

    describe 'clicked test drive button', ->

      it 'should set the target state on state manager to Testing', ->
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @buildScreenStateManager.targetState).toEqual 'Testing'

      it 'should go to state Rasterizing', ->
        sinon.spy @buildScreenStateManager, 'goToState'
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalled 'Rasterizing'

      it 'should tell the Rasterizing state to start rasterization', ->
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @delegateMock.startRasterizing).toHaveBeenCalled()

      it 'should set the state manager´s target state to Testing', ->
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @buildScreenStateManager.targetState).toEqual 'Testing'


  describe 'rasterizing', ->

    beforeEach ->
      @buildScreenStateManager = BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Rasterizing'

    it 'should prepare rasterizing environment on entering the state', ->
      (expect @delegateMock.setupRasterizing).toHaveBeenCalled()

    it 'should tear rasterizing environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownRasterizing).toHaveBeenCalled()

    describe 'start rasterization', ->

      it 'should start rasterization process', ->
        @buildScreenStateManager.send 'rasterize'

        (expect @delegateMock.startRasterizing).toHaveBeenCalled()

    describe 'finished rasterization', ->

      beforeEach ->
        @targetState = 'RandomState'
        @buildScreenStateManager.targetState = @targetState

      it 'should leave the state towards the state manager´s target state', ->
        sinon.spy @buildScreenStateManager, 'goToState'

        @buildScreenStateManager.send 'finishedRasterizing'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith @targetState
