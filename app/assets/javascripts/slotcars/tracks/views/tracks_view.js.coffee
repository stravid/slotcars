
#= require slotcars/tracks/templates/tracks_view_template

#= require helpers/namespace

namespace 'slotcars.tracks.views'

slotcars.tracks.views.TracksView = Ember.View.extend
  controller: null

  templateName: 'slotcars_tracks_templates_tracks_view_template'
  elementId: 'tracks-view'