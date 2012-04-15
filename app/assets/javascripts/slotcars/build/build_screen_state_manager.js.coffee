
(namespace 'Slotcars.build').BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  targetState: null
  originState: null

  Drawing: Ember.State.create
    enter: (manager) -> manager.delegate.setupDrawing()
    finishedDrawing: (manager) -> manager.goToState 'Editing'
    exit: (manager) -> manager.delegate.teardownDrawing()

  Editing: Ember.State.create
    accessibleStates: ['Testing']

    clickedTestdriveButton: (manager) ->
      manager.originState = @name
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
    finishedRasterizing: (manager) -> manager.goToState manager.targetState
    canceledRasterizing: (manager) -> manager.goToState manager.originState
    exit: (manager) -> manager.delegate.teardownRasterizing()

