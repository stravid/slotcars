Tracks.TracksController = Ember.Object.extend

  tracksScreenView: null

  pageATracks: null
  pageBTracks: null
  pageCTracks: null
  tracksPerPage: null

  init: ->
    @tracksPerPage = 3

    @tracksView = Tracks.TracksView.create
      tracksController: this
      swipeTreshhold: 100
      currentPage: 1
      tracksPerPage: @tracksPerPage

    @_loadTrackCount (trackCount) => @tracksView.set 'trackCount', trackCount

    @set 'pageATracks', []
    @set 'pageBTracks', Shared.Track.find { offset: 0, limit: @tracksPerPage }
    @set 'pageCTracks', Shared.Track.find { offset: @tracksPerPage, limit: @tracksPerPage }

    @tracksScreenView.set 'contentView', @tracksView

  reloadPageATracks: (offset) ->
    (@set 'pageATracks', Shared.Track.find { offset: offset, limit: @tracksPerPage }) if offset >= 0

  reloadPageBTracks: (offset) ->
    (@set 'pageBTracks', Shared.Track.find { offset: offset, limit: @tracksPerPage }) if offset >= 0

  reloadPageCTracks: (offset) ->
    (@set 'pageCTracks', Shared.Track.find { offset: offset, limit: @tracksPerPage }) if offset >= 0

  _loadTrackCount: (callback) ->
    jQuery.ajax "/api/tracks/count",
      type: "GET"
      dataType: 'json'
      success: (response) -> callback response