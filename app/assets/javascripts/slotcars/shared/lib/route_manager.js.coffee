Shared.RouteState = Ember.State.extend
  exit: (manager) -> manager.delegate.destroyCurrentScreen()

Shared.BrowserSupportable = Ember.Mixin.create
  enter: (manager) ->
    if manager.delegate.isBrowserSupported() then @_super manager
    else manager.transitionTo 'Unsupported'

Shared.RouteManager = Ember.RouteManager.extend

  wantsHistory: true # use html5 push state
  baseURI: window.location.origin || ( window.location.protocol + "//" + window.location.host )
  delegate: null

  init: ->
    @_super()
    validStates = ['Home', 'Build', 'Play', 'Quickplay', 'Tracks', 'Error']
    Shared.BrowserSupportable.apply @states[state] for state in validStates

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

  Unsupported: Shared.RouteState.create
    route: 'unsupported'
    enter: (manager) -> manager.delegate.showScreen 'UnsupportedScreen'

  404: Ember.State.create
    enter: (manager) -> manager.transitionTo 'Error'
