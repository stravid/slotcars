
#= require helpers/namespace
#= require community/views/tracks/tracks_new_view
#= require builder/builder_application

namespace 'community.states.tracks'

community.states.tracks.TracksNewState = Ember.State.create

  route: 'new'

  enter: (manager) ->
    manager.tracksNewView = community.views.tracks.TracksNewView.create
      builderApplication: builder.BuilderApplication.create()

    manager.communityView.set 'contentView', manager.tracksNewView
