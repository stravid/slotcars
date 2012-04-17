
#= require slotcars/shared/models/track
#= require slotcars/tracks/views/tracks_view

Track = slotcars.shared.models.Track
TracksView = slotcars.tracks.views.TracksView

(namespace 'slotcars.tracks.controllers').TracksController = Ember.Object.extend

  tracksScreenView: null

  pageATracks: null
  pageBTracks: null
  pageCTracks: null
  tracksPerPage: null

  init: ->
    @tracksPerPage = 4

    @tracksView = TracksView.create
      tracksController: this
      swipeTreshhold: 100
      currentPage: 1
      tracksPerPage: @tracksPerPage

    @set 'pageATracks', []
    @set 'pageBTracks', Track.find { offset: 0, limit: @tracksPerPage }
    @set 'pageCTracks', Track.find { offset: 4, limit: @tracksPerPage }

    @tracksScreenView.set 'contentView', @tracksView

  reloadPageATracks: (offset) -> @set 'pageATracks', Track.find { offset: offset, limit: @tracksPerPage }

  reloadPageBTracks: (offset) -> @set 'pageBTracks', Track.find { offset: offset, limit: @tracksPerPage }

  reloadPageCTracks: (offset) -> @set 'pageCTracks', Track.find { offset: offset, limit: @tracksPerPage }
