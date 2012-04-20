Build.BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  targetState: null
  publishingFallbackState: null

  Drawing: Ember.State.create
    enter: (manager) -> manager.delegate.setupDrawing()
    finishedDrawing: (manager) ->
      manager.goToState 'Editing'
      manager.send 'clickedTestdriveButton' # bridges Editing state
    exit: (manager) -> manager.delegate.teardownDrawing()

  Editing: Ember.State.create
    # states which are reachable from 'Editing' - used for menu button states in the build screen (enable/disable)
    reachableStates: ['Testing', 'Publishing']

    clickedTestdriveButton: (manager) ->
      manager.targetState = 'Testing'
      manager.goToState 'Rasterizing'
      manager.send 'rasterize'
    clickedPublishButton: (manager) ->
      manager.publishingFallbackState = @name
      manager.targetState = 'Publishing'
      manager.goToState 'Rasterizing'
      manager.send 'rasterize'

  Testing: Ember.State.create
    # states which are reachable from 'Testing' - used for menu button states in the build screen (enable/disable)
    reachableStates: ['Drawing', 'Publishing']

    enter: (manager) -> manager.delegate.setupTesting()
    clickedDrawButton: (manager) -> manager.goToState 'Drawing'
    clickedPublishButton: (manager) ->
      manager.publishingFallbackState = @name
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
    clickedCancelButton: (manager) -> manager.goToState manager.publishingFallbackState
    exit: (manager) -> manager.delegate.teardownPublishing()
