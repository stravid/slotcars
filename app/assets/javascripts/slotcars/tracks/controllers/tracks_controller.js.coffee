Tracks.TracksController = Ember.Object.extend

  tracksScreenView: null

  pageATracks: null
  pageBTracks: null
  pageCTracks: null
  tracksPerPage: null

  init: ->
    @tracksPerPage = 4

    @tracksView = Tracks.TracksView.create
      tracksController: this
      swipeTreshhold: 100
      currentPage: 1
      tracksPerPage: @tracksPerPage

    @set 'pageATracks', []
    @set 'pageBTracks', Shared.Track.find { offset: 0, limit: @tracksPerPage }
    @set 'pageCTracks', Shared.Track.find { offset: 4, limit: @tracksPerPage }

    @tracksScreenView.set 'contentView', @tracksView

  reloadPageATracks: (offset) -> @set 'pageATracks', Shared.Track.find { offset: offset, limit: @tracksPerPage }

  reloadPageBTracks: (offset) -> @set 'pageBTracks', Shared.Track.find { offset: offset, limit: @tracksPerPage }

  reloadPageCTracks: (offset) -> @set 'pageCTracks', Shared.Track.find { offset: offset, limit: @tracksPerPage }
