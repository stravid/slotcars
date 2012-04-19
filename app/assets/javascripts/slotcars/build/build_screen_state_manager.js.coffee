Build.BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  targetState: null
  originState: null

  Drawing: Ember.State.create
    enter: (manager) -> manager.delegate.setupDrawing()
    finishedDrawing: (manager) ->
      manager.goToState 'Editing'
      manager.send 'clickedTestdriveButton' # bridges Editing state
    exit: (manager) -> manager.delegate.teardownDrawing()

  Editing: Ember.State.create
    accessibleStates: ['Testing', 'Publishing']

    clickedTestdriveButton: (manager) ->
      manager.targetState = 'Testing'
      manager.goToState 'Rasterizing'
      manager.send 'rasterize'
    clickedPublishButton: (manager) ->
      manager.originState = @name
      manager.targetState = 'Publishing'
      manager.goToState 'Rasterizing'
      manager.send 'rasterize'

  Testing: Ember.State.create
    accessibleStates: ['Drawing', 'Publishing']

    enter: (manager) -> manager.delegate.setupTesting()
    clickedDrawButton: (manager) -> manager.goToState 'Drawing'
    clickedPublishButton: (manager) ->
      manager.originState = @name
      manager.goToState 'Publishing'
    exit: (manager) -> manager.delegate.teardownTesting()

  Rasterizing: Ember.State.create
    enter: (manager) -> manager.delegate.setupRasterizing()
    rasterize: (manager) -> manager.delegate.startRasterizing()
    finishedRasterization: (manager) -> manager.goToState manager.targetState
    exit: (manager) -> manager.delegate.teardownRasterizing()

  Publishing: Ember.State.create
    enter: (manager) -> manager.delegate.setupPublishing()
    clickedPublishButton: (manager) -> manager.delegate.performPublishing()
    clickedCancelButton: (manager) -> manager.goToState manager.originState
    exit: (manager) -> manager.delegate.teardownPublishing()
