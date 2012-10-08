Shared.RouteState = Ember.State.extend
  exit: (manager) -> manager.delegate.destroyCurrentScreen()

Shared.RouteManager = Ember.RouteManager.extend

  wantsHistory: true # use html5 push state
  baseURI: window.location.origin || ( window.location.protocol + "//" + window.location.host )
  delegate: null

  Build: Shared.RouteState.create
    route: 'build'
    enter: (manager) -> manager.delegate.showScreen 'BuildScreen'

  Quickplay: Shared.RouteState.create
    route: 'quickplay'
    enter: (manager) -> Ember.run.later ( => manager.delegate.showScreen 'PlayScreen' ), 500
    quickplay: (manager) ->
      manager.delegate.destroyCurrentScreen()
      Ember.run.later ( => manager.delegate.showScreen 'PlayScreen' ), 500

  Play: Shared.RouteState.create
    route: 'play/:id'
    enter: (manager) ->
      manager.delegate.showScreen 'PlayScreen', trackId: (parseInt manager.getPath 'params.id')
    quickplay: (manager) -> manager.transitionTo 'Quickplay'

  Tracks: Shared.RouteState.create
    route: 'tracks'
    enter: (manager) -> manager.delegate.showScreen 'TracksScreen'

  Error: Shared.RouteState.create
    route: 'error'
    enter: (manager) -> manager.delegate.showScreen 'ErrorScreen'

  Home: Shared.RouteState.create
    route: ''
    enter: (manager) -> manager.delegate.showScreen 'HomeScreen'

  404: Ember.State.create
    enter: (manager) -> manager.transitionTo 'Error'
