
#= require helpers/namespace

namespace 'slotcars.build'

slotcars.build.BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  initialState: 'Initialize'

  Initialize: Ember.State.create

    enter: (manager) -> manager.delegate.initialize()

    initialized: (manager) -> manager.goToState 'Drawing'

  Drawing: Ember.State.create

    enter: (manager) -> manager.delegate.startDrawing()