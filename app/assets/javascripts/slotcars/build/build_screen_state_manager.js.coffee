Build.BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  targetState: null

  Drawing: Ember.State.create
    enter: (manager) -> manager.delegate.setupDrawing()
    finishedDrawing: (manager) -> manager.goToState 'Editing'
    exit: (manager) -> manager.delegate.teardownDrawing()

  Editing: Ember.State.create
    accessibleStates: ['Testing']

    clickedTestdriveButton: (manager) ->
      manager.targetState = 'Testing'
      manager.goToState 'Rasterizing'
      manager.send 'rasterize'

  Testing: Ember.State.create
    accessibleStates: ['Drawing']

    enter: (manager) -> manager.delegate.setupTesting()
    clickedDrawButton: (manager) -> manager.goToState 'Drawing'
    exit: (manager) -> manager.delegate.teardownTesting()

  Rasterizing: Ember.State.create
    enter: (manager) -> manager.delegate.setupRasterizing()
    rasterize: (manager) -> manager.delegate.startRasterizing()
    finishedRasterization: (manager) -> manager.goToState manager.targetState
    exit: (manager) -> manager.delegate.teardownRasterizing()

