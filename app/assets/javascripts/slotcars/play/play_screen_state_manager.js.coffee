
namespace('slotcars.play').PlayScreenStateManager = Ember.StateManager.extend

  initialState: 'Loading'
  delegate: null

  Loading: Ember.State.create
    load: (manager) -> manager.delegate.load()
    loaded: (manager) ->
      manager.goToState 'Initializing'
      manager.send 'initialize'

  Initializing: Ember.State.create
    initialize: (manager) -> manager.delegate.initialize()
    initialized: (manager) -> manager.goToState 'Playing'

  Playing: Ember.State.create
    enter: (manager) -> manager.delegate.play()
