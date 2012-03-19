
#= require slotcars/shared/models/track
#= require slotcars/shared/models/model_store
#= require slotcars/tracks/views/tracks_view

#= require helpers/namespace

namespace 'slotcars.tracks.controllers'

ModelStore = slotcars.shared.models.ModelStore
Track = slotcars.shared.models.Track
TracksView = slotcars.tracks.views.TracksView

slotcars.tracks.controllers.TracksController = Ember.Object.extend

  tracksScreenView: null
  tracks: null

  init: ->
    @tracks = ModelStore.findAll Track
    @tracksView = TracksView.create
      controller: this

    @tracksScreenView.set 'contentView', @tracksView