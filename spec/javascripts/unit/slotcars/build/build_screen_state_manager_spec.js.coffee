describe 'build screen state manager', ->

  beforeEach ->
    @delegateMock =
      setupDrawing: sinon.spy()
      teardownDrawing: sinon.spy()
      setupEditing: sinon.spy()
      teardownEditing: sinon.spy()
      setupTesting: sinon.spy()
      teardownTesting: sinon.spy()
      setupRasterizing: sinon.spy()
      startRasterizing: sinon.spy()
      teardownRasterizing: sinon.spy()
      setupPublishing: sinon.spy()
      performPublishing: sinon.spy()
      teardownPublishing: sinon.spy()

  it 'should extend Ember.StateManager', ->
    (expect Build.BuildScreenStateManager).toExtend Ember.StateManager


  describe 'drawing', ->

    beforeEach ->
      @buildScreenStateManager = Build.BuildScreenStateManager.create
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
      @buildScreenStateManager = Build.BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Testing'

    it 'should prepare test drive environment on entering the state', ->
      (expect @delegateMock.setupTesting).toHaveBeenCalled()

    it 'should tear test drive environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownTesting).toHaveBeenCalled()

    describe 'clicked draw button', ->

      it 'should go to state Drawing', ->
        sinon.spy @buildScreenStateManager, 'goToState'
        @buildScreenStateManager.send 'clickedDrawButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Drawing'

    describe 'clicked edit button', ->

      it 'should go to state Editing', ->
        sinon.spy @buildScreenStateManager, 'goToState'
        @buildScreenStateManager.send 'clickedEditButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Editing'

    describe 'clicked publish button', ->

      beforeEach ->
        sinon.spy @buildScreenStateManager, 'goToState'

      it 'should set the current state as fallback state', ->
        @buildScreenStateManager.send 'clickedPublishButton'

        (expect @buildScreenStateManager.publishingFallbackState).toEqual 'Testing'

      it 'should go to state Publishing', ->
        @buildScreenStateManager.send 'clickedPublishButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Publishing'


  describe 'editing', ->

    beforeEach ->
      @buildScreenStateManager = Build.BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Editing'

    it 'should prepare editing environment on entering the state', ->
      (expect @delegateMock.setupEditing).toHaveBeenCalled()

    it 'should tear editing environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownEditing).toHaveBeenCalled()

    describe 'clicked test drive button', ->

      it 'should set the state manager´s target state to Testing', ->
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @buildScreenStateManager.targetState).toEqual 'Testing'

      it 'should go to state Rasterizing', ->
        sinon.spy @buildScreenStateManager, 'goToState'
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Rasterizing'

      it 'should tell the Rasterizing state to start rasterization', ->
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @delegateMock.startRasterizing).toHaveBeenCalled()

    describe 'clicked publish button', ->

      beforeEach ->
        sinon.spy @buildScreenStateManager, 'goToState'

      it 'should set the state manager´s target state to Publishing', ->
        @buildScreenStateManager.send 'clickedPublishButton'

        (expect @buildScreenStateManager.targetState).toEqual 'Publishing'

      it 'should set the current state as fallback state', ->
        @buildScreenStateManager.send 'clickedPublishButton'

        (expect @buildScreenStateManager.publishingFallbackState).toEqual 'Editing'

      it 'should go to state Rasterizing', ->
        @buildScreenStateManager.send 'clickedPublishButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Rasterizing'

      it 'should tell the Rasterizing state to start rasterization', ->
        @buildScreenStateManager.send 'clickedTestdriveButton'

        (expect @delegateMock.startRasterizing).toHaveBeenCalled()

    describe 'clicked draw button', ->

      beforeEach ->
        sinon.spy @buildScreenStateManager, 'goToState'

      it 'should go to state Drawing', ->
        @buildScreenStateManager.send 'clickedDrawButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith 'Drawing'


  describe 'rasterizing', ->

    beforeEach ->
      @buildScreenStateManager = Build.BuildScreenStateManager.create
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
        @targetState = 'Publishing'
        @buildScreenStateManager.targetState = @targetState

      it 'should leave the state towards the state manager´s target state', ->
        sinon.spy @buildScreenStateManager, 'goToState'

        @buildScreenStateManager.send 'finishedRasterization'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith @targetState


  describe 'publishing', ->

    beforeEach ->
      @buildScreenStateManager = Build.BuildScreenStateManager.create
        delegate: @delegateMock

      @buildScreenStateManager.goToState 'Publishing'

    it 'should prepare publishing environment on entering the state', ->
      (expect @delegateMock.setupPublishing).toHaveBeenCalled()

    it 'should tear publishing environment down on leaving the state', ->
      @buildScreenStateManager.send 'exit'

      (expect @delegateMock.teardownPublishing).toHaveBeenCalled()

    describe 'performing publication', ->

      it 'should save track', ->
        @buildScreenStateManager.send 'clickedPublishButton'

        (expect @delegateMock.performPublishing).toHaveBeenCalled()

    describe 'canceling publication', ->

      beforeEach ->
        @fallbackState = 'Testing'
        @buildScreenStateManager.publishingFallbackState = @fallbackState

      it 'should fall back to the previous state', ->
        sinon.spy @buildScreenStateManager, 'goToState'

        @buildScreenStateManager.send 'clickedCancelButton'

        (expect @buildScreenStateManager.goToState).toHaveBeenCalledWith @fallbackState
