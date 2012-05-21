Shared.RouteManager = Ember.RouteManager.extend

  wantsHistory: true # use html5 push state
  delegate: null
  baseURI: window.location.origin || ( window.location.protocol + "//" + window.location.host )

  Build: Ember.State.create
    route: 'build'
    enter: (manager) -> manager.delegate.showScreen 'BuildScreen'

  Quickplay: Ember.State.create
    route: 'quickplay'
    enter: (manager) -> manager.delegate.showScreen 'PlayScreen'

  Play: Ember.State.create
    route: 'play/:id'
    enter: (manager) -> 
      manager.delegate.showScreen 'PlayScreen', trackId: (parseInt manager.getPath 'params.id')

  Tracks: Ember.State.create
    route: 'tracks'
    enter: (manager) -> manager.delegate.showScreen 'TracksScreen'

  Home: Ember.State.create
    route: ''
    enter: (manager) -> manager.delegate.showScreen 'HomeScreen'
