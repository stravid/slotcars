
#= require helpers/namespace
#= require community/views/tracks/tracks_show_view
#= require game/game_application
#= require shared/model_store

namespace 'community.states.tracks'

community.states.tracks.TracksShowState = Ember.State.create

  route: ':id'

  enter: (manager) ->
    manager.goToState 'Play'

  Play: Ember.State.create

    enter: (manager) ->
      manager.tracksShowView = community.views.tracks.TracksShowView.create
        gameApplication: game.GameApplication.create()

      manager.communityView.set 'contentView', manager.tracksShowView
