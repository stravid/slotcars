
#= require helpers/namespace

namespace 'slotcars.build'

slotcars.build.BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  initialState: 'Building'

  Building: Ember.State.create

    enter: (manager) -> manager.delegate.appendScreen()

    destroy: (manager) -> manager.goToState 'Destroying'

    exit: (manager) -> manager.delegate.removeScreen()

  Destroying: Ember.State.create()