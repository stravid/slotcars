
#= require helpers/namespace

namespace 'slotcars.play'

slotcars.play.PlayScreenStateManager = Ember.StateManager.extend

  initialState: 'Loading'
  enableLogging: true
  delegate: null

  Loading: Ember.State.create
    enter: (manager) -> manager.delegate.load()
    loaded: (manager) -> manager.goToState 'Initializing'

  Initializing: Ember.State.create
    enter: (manager) -> manager.delegate.initialize()
    initialized: (manager) -> manager.goToState 'Playing'

  Playing: Ember.State.create
    enter: (manager) -> manager.delegate.play()
