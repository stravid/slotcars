#= require helpers/namespace
#= require embient/ember-routemanager
#= require shared/model_store
#= require shared/models/track_model

namespace 'game'

game.GameStateManager = Ember.RouteManager.extend

  wantsHistory: true
  baseURI: window.location.origin
  application: null

  start: Ember.State.create()

  Load: Ember.State.create

    route: 'tracks/:id'

    enter: (manager) ->
      id = manager.getPath 'params.id'
      track = shared.ModelStore.findByClientId shared.models.TrackModel, id

      if (track.get 'path')
        manager.application.trackMediator.set 'currentTrack', track
        manager.application.start()