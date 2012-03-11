#= require helpers/namespace

#= require embient/ember-routemanager

namespace 'slotcars'

slotcars.RouteManager = Ember.RouteManager.extend

  wantsHistory: true # use html5 push state
  delegate: null
  baseURI: window.location.origin || ( window.location.protocol + "//" + window.location.host )

  Build: Ember.State.create
    route: 'build'
    enter: (manager) -> manager.delegate.showBuildScreen()

  Play: Ember.State.create
    route: 'play/:id'
    enter: (manager) -> manager.delegate.showPlayScreen (manager.getPath 'params.id')

  Tracks: Ember.State.create
    route: 'tracks'
    enter: (manager) -> manager.delegate.showTracksScreen()

  Home: Ember.State.create
    route: ''
    enter: (manager) ->
      manager.delegate.showHomeScreen()