#= require helpers/namespace
#= require community/templates/tracks/new_template
#= require builder/builder_application
#= require shared/mediators/current_track_mediator

namespace 'community.views.tracks'

community.views.tracks.TracksNewView = Ember.View.extend

  elementId: 'tracks-new-view'
  templateName: 'community_templates_tracks_new_template'

  currentTrackMediator: shared.mediators.currentTrackMediator
  builderApplication: null
