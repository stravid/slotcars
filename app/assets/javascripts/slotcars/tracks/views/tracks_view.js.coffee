
#= require slotcars/shared/views/thumbnail_track_view
#= require slotcars/tracks/templates/tracks_view_template
#= require slotcars/tracks/views/page_view

Tracks.TracksView = Ember.View.extend

  templateName: 'slotcars_tracks_templates_tracks_view_template'
  elementId: 'tracks-view'

  tracksController: null
  swipeTreshhold: null
  currentPage: null
  tracksPerPage: null

  swipeStartPosition: null
  lastSwipePosition: null
  pages: null
  pageViewA: null
  pageViewB: null
  pageViewC: null
  width: null

  didInsertElement: ->
    @width = (@$ '#swiper').width()

    @pageViewA = Tracks.PageView.create
      origin: -1 * @width
      tracksController: @tracksController
      tracksBinding: 'tracksController.pageATracks'

    @pageViewB = Tracks.PageView.create
      origin: 0
      tracksController: @tracksController
      tracksBinding: 'tracksController.pageBTracks'

    @pageViewC = Tracks.PageView.create
      origin: @width
      tracksController: @tracksController
      tracksBinding: 'tracksController.pageCTracks'

    @set 'dynamicViewPageA', @pageViewA
    @set 'dynamicViewPageB', @pageViewB
    @set 'dynamicViewPageC', @pageViewC

    @pages = [ @pageViewA, @pageViewB, @pageViewC ]

    (@$ '#swiper').on 'touchMouseDown', (event) => @onTouchMouseDown event

  onTouchMouseDown: (event) ->
    @bindTrackSelectionHandler()

    page.disableTransitions() for page in @pages

    @swipeStartPosition = event.pageX

    (@$ '#swiper').on 'touchMouseMove', (event) => @onTouchMouseMove event
    (@$ '#swiper').on 'touchMouseUp', (event) => @onTouchMouseUp event

  onTouchMouseMove: (event) ->
    @unbindTrackSelectionHandler()

    @moveWithUserMovement event.pageX - @swipeStartPosition

    @lastSwipePosition = event.pageX

  onTouchMouseUp: (event) ->
    (@$ '#swiper').off 'touchMouseMove'
    (@$ '#swiper').off 'touchMouseUp'

    @onSwipeEnd @lastSwipePosition - @swipeStartPosition

  onSwipeEnd: (delta) ->
    return if @currentPage is 1 && delta > 0

    if (Math.abs delta) > @swipeTreshhold
      @swipe delta
    else
      @movePagesToOrigin()

  swipe: (direction) ->
    if direction > 0 and @currentPage > 1
      @swipeToTheRight()
    else
      @swipeToTheLeft()

    page.moveToOrigin() for page in @pages

  swipeToTheRight: ->
    @pages[0].setOrigin 0
    @pages[0].enableTransitions()

    @pages[1].setOrigin @width
    @pages[1].enableTransitions()

    @pages[2].setOrigin -1 * @width

    # load new data, decrement currentPage
    @currentPage--
    @loadData @pages[2], @tracksPerPage * (@currentPage - 2)

    @pages.unshift @pages.pop()

  swipeToTheLeft: ->
    @pages[0].setOrigin @width

    @pages[1].setOrigin -1 * @width
    @pages[1].enableTransitions()

    @pages[2].setOrigin 0
    @pages[2].enableTransitions()

    # load new data, increment currentPage
    @currentPage++
    @loadData @pages[0], @tracksPerPage * @currentPage

    @pages.push @pages.shift()

  loadData: (page, offset) ->
    switch page
      when @pageViewA then @tracksController.reloadPageATracks offset
      when @pageViewB then @tracksController.reloadPageBTracks offset
      when @pageViewC then @tracksController.reloadPageCTracks offset

  movePagesToOrigin: ->
    for page in @pages
      page.enableTransitions()
      page.moveToOrigin()

  moveWithUserMovement: (delta) ->
    return if @currentPage is 1 && delta > 0

    page.moveTo delta for page in @pages

  bindTrackSelectionHandler: -> @$().on 'touchMouseUp', '.track', -> Shared.routeManager.set 'location', "play/#{$(this).attr 'data-track-id'}"

  unbindTrackSelectionHandler: -> @$().off 'touchMouseUp', '.track'
