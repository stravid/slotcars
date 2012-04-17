
#= require slotcars/shared/models/track
#= require slotcars/tracks/views/tracks_view

Track = slotcars.shared.models.Track
TracksView = slotcars.tracks.views.TracksView

(namespace 'slotcars.tracks.controllers').TracksController = Ember.Object.extend

  tracksScreenView: null

  pageATracks: null
  pageBTracks: null
  pageCTracks: null

  init: ->
    @tracksView = TracksView.create
      controller: this
      swipeTreshhold: 100
      currentPage: 1

    @set 'pageATracks', []
    @set 'pageBTracks', Track.find { offset: 0, limit: 4 }
    @set 'pageCTracks', Track.find { offset: 4, limit: 4 }

    @tracksScreenView.set 'contentView', @tracksView

  reloadPageATracks: (offset) -> @set 'pageATracks', Track.find { offset: offset, limit: 4 }

  reloadPageBTracks: (offset) -> @set 'pageBTracks', Track.find { offset: offset, limit: 4 }

  reloadPageCTracks: (offset) -> @set 'pageCTracks', Track.find { offset: offset, limit: 4 }
