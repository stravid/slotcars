
#= require helpers/namespace
#= require embient/ember-layout
#= require community/templates/tracks/show_template
#= require shared/mediators/tracks_mediator

namespace 'community.views'

community.views.tracks.TracksShowView = Ember.View.extend

  elementId: 'play-view'
  templateName: 'community_templates_tracks_show_template'

  tracksMediator: shared.mediators.tracksMediator
  gameApplication: null

  linkToCreateTrackBinding: 'tracksMediator.createRoute'