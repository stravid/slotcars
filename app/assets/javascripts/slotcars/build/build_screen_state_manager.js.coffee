
(namespace 'Slotcars.build').BuildScreenStateManager = Ember.StateManager.extend

  delegate: null

  Drawing: Ember.State.create
    enter: (manager) -> manager.delegate.setupDrawing()
    exit: (manager) -> manager.delegate.teardownDrawing()

  Testing: Ember.State.create
    enter: (manager) -> manager.delegate.setupTesting()
    exit: (manager) -> manager.delegate.teardownTesting()
