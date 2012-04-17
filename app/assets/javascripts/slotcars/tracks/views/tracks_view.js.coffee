
#= require slotcars/shared/views/thumbnail_track_view
#= require slotcars/tracks/templates/tracks_view_template
#= require slotcars/tracks/views/page_view

#= require helpers/namespace

namespace 'slotcars.tracks.views'

PageView = slotcars.tracks.views.PageView

slotcars.tracks.views.TracksView = Ember.View.extend

  templateName: 'slotcars_tracks_templates_tracks_view_template'
  elementId: 'tracks-view'

  controller: null
  swipeTreshhold: null
  currentPage: null

  swipeStart: null
  lastSwipePosition: null
  pages: null
  pageViewA: null
  pageViewB: null
  pageViewC: null
  width: null

  didInsertElement: ->
    @width = (@$ '#swiper').width()

    @pageViewA = PageView.create
      origin: -1 * @width
      controller: @controller
      tracksBinding: 'controller.pageATracks'

    @pageViewB = PageView.create
      origin: 0
      controller: @controller
      tracksBinding: 'controller.pageBTracks'

    @pageViewC = PageView.create
      origin: @width
      controller: @controller
      tracksBinding: 'controller.pageCTracks'

    @set 'dynamicViewPageA', @pageViewA
    @set 'dynamicViewPageB', @pageViewB
    @set 'dynamicViewPageC', @pageViewC

    @pages = [ @pageViewA, @pageViewB, @pageViewC ]

    (@$ '#swiper').on 'touchMouseDown', (event) => @onTouchMouseDown event

  onTouchMouseDown: (event) ->
    @bindTrackSelectionHandler()

    page.disableTransitions() for page in @pages

    @swipeStart = event.pageX

    (@$ '#swiper').on 'touchMouseMove', (event) => @onTouchMouseMove event
    (@$ '#swiper').on 'touchMouseUp', (event) => @onTouchMouseUp event

  onTouchMouseMove: (event) ->
    @unbindTrackSelectionHandler()

    @moveWithUserMovement event.pageX - @swipeStart

    @lastSwipePosition = event.pageX

  onTouchMouseUp: (event) ->
    (@$ '#swiper').off 'touchMouseMove'
    (@$ '#swiper').off 'touchMouseUp'

    @onSwipeEnd @lastSwipePosition - @swipeStart

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
    @loadData @pages[2], 4 * (@currentPage - 2)

    @pages.unshift @pages.pop()

  swipeToTheLeft: ->
    @pages[0].setOrigin @width

    @pages[1].setOrigin -1 * @width
    @pages[1].enableTransitions()

    @pages[2].setOrigin 0
    @pages[2].enableTransitions()

    # load new data, increment currentPage
    @currentPage++
    @loadData @pages[0], 4 * @currentPage

    @pages.push @pages.shift()

  loadData: (page, offset) ->
    switch page
      when @pageViewA then @controller.reloadPageATracks offset
      when @pageViewB then @controller.reloadPageBTracks offset
      when @pageViewC then @controller.reloadPageCTracks offset

  movePagesToOrigin: ->
    for page in @pages
      page.enableTransitions()
      page.moveToOrigin()

  moveWithUserMovement: (delta) ->
    return if @currentPage is 1 && delta > 0

    page.moveTo delta for page in @pages

  bindTrackSelectionHandler: -> @$().on 'touchMouseUp', '.track', -> slotcars.routeManager.set 'location', "play/#{$(this).attr 'data-track-id'}"

  unbindTrackSelectionHandler: -> @$().off 'touchMouseUp', '.track'
