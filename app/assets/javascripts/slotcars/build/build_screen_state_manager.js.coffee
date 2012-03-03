
#= require helpers/namespace

namespace 'slotcars.build'

slotcars.build.BuildScreenStateManager = Ember.StateManager.extend

  delegate: null
  initialState: 'Building'

  Building: Ember.State.create

    enter: (manager) -> manager.delegate.appendScreen()
    destroyScreen: (manager) -> manager.goToState 'Destroying'
    exit: (manager) -> manager.delegate.removeScreen()

    initialState: 'Appending'

    Appending: Ember.State.create
      appendedScreen: (manager) -> manager.goToState 'Loading'

    Loading: Ember.State.create
      enter: (manager) -> manager.delegate.loadTrack()
      newTrackCreated: (manager) -> manager.goToState 'Drawing'

    Drawing: Ember.State.create
      enter: (manager) -> manager.delegate.startDrawMode()
      exit: (manager) -> manager.delegate.cleanupDrawMode()

  Destroying: Ember.State.create()