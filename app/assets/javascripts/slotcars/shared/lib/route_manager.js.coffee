Shared.RouteManager = Ember.RouteManager.extend

  wantsHistory: true # use html5 push state
  baseURI: window.location.origin || ( window.location.protocol + "//" + window.location.host )
  delegate: null

  Build: Ember.State.create
    route: 'build'
    enter: (manager) -> manager.delegate.showScreen 'BuildScreen'

  Quickplay: Ember.State.create
    route: 'quickplay'
    enter: (manager) -> Ember.run.later ( => manager.delegate.showScreen 'PlayScreen' ), 500
    quickplay: (manager) ->
      manager.delegate.destroyCurrentScreen()
      Ember.run.later ( => manager.delegate.showScreen 'PlayScreen' ), 500

  Play: Ember.State.create
    route: 'play/:id'
    enter: (manager) ->
      manager.delegate.showScreen 'PlayScreen', trackId: (parseInt manager.getPath 'params.id')
    quickplay: (manager) -> manager.transitionTo 'Quickplay'

  Tracks: Ember.State.create
    route: 'tracks'
    enter: (manager) -> manager.delegate.showScreen 'TracksScreen'

  Error: Ember.State.create
    route: 'error'
    enter: (manager) -> manager.delegate.showScreen 'ErrorScreen'

  Home: Ember.State.create
    route: ''
    enter: (manager) -> manager.delegate.showScreen 'HomeScreen'

  404: Ember.State.create
    enter: (manager) ->
      manager.allowLocationUpdate()
      manager.set 'location', 'error'

  allowLocationUpdate: -> @_skipPush = false
