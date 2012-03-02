#= require helpers/namespace

#= require embient/ember-routemanager

namespace 'slotcars'

slotcars.RouteManager = Ember.RouteManager.extend
  application: null

  Build: Ember.State.create
    route: 'build'
    enter: (manager) -> manager.application.showBuildScreen()

  Play: Ember.State.create
    route: 'play/:id'
    enter: (manager) -> manager.application.showPlayScreen (manager.getPath 'params.id')

  Tracks: Ember.State.create
    route: 'tracks'
    enter: (manager) -> manager.application.showTracksScreen()

  Home: Ember.State.create
    route: ''
    enter: (manager) -> manager.application.showHomeScreen()