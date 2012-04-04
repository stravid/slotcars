
(namespace 'Slotcars.build').BuildScreenStateManager = Ember.StateManager.extend

  initialState: 'Drawing'
  delegate: null

  Drawing: Ember.State.create
    enter: (manager) -> manager.delegate.prepareDrawing()
    exit: (manager) -> manager.delegate.teardownDrawing()

  Testing: Ember.State.create
    enter: (manager) -> manager.delegate.prepareTesting()
    exit: (manager) -> manager.delegate.teardownTesting()
