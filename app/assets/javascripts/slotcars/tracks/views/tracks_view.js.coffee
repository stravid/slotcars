Tracks.TracksView = Ember.View.extend

  templateName: 'slotcars_tracks_templates_tracks_view_template'
  elementId: 'tracks-view'

  tracksController: null
  swipeTreshhold: null
  currentPage: null
  tracksPerPage: null
  trackCount: null

  swipeStartPosition: null
  lastSwipePosition: null
  pages: null
  pageViewA: null
  pageViewB: null
  pageViewC: null
  width: null
  pageCount: null

  isFirstPage: true
  isLastPage: false

  onTrackCountChange: ( ->
    @set 'pageCount', Math.ceil @trackCount / @tracksPerPage
  ).observes 'trackCount'

  onCurrentPageChange: ( ->
    @set 'isFirstPage', @currentPage is 1
    @set 'isLastPage', @currentPage is @pageCount
  ).observes 'currentPage'

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

    @pageViewA.appendTo '#swiper'
    @pageViewB.appendTo '#swiper'
    @pageViewC.appendTo '#swiper'

    @pages = [ @pageViewA, @pageViewB, @pageViewC ]

    (@$ '#swiper').on 'touchMouseDown', (event) => @onTouchMouseDown event
    (jQuery document).on 'keydown.swipable', (event) => @onKeyDown event

  willDestroy: ->
    (jQuery document).off 'keydown.swipable'
    @_super()

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

    @onSwipeEnd @lastSwipePosition - @swipeStartPosition if @lastSwipePosition?

  onKeyDown: (event) ->
    if event.keyCode == 37 then @onPreviousButtonClicked()
    else if event.keyCode == 39 then @onNextButtonClicked()

  onNextButtonClicked: -> @swipe -1

  onPreviousButtonClicked: -> @swipe 1

  onSwipeEnd: (delta) ->
    return if @currentPage is 1 && delta > 0

    if (Math.abs delta) > @swipeTreshhold
      @swipe delta
    else
      @movePagesToOrigin()

    @lastSwipePosition = null

  swipe: (direction) ->
    if direction > 0 and @currentPage > 1
      @swipeToTheRight()
    else if direction < 0 and @currentPage < @pageCount
      @swipeToTheLeft()

    page.moveToOrigin() for page in @pages

  swipeToTheRight: ->
    @pages[0].setOrigin 0
    @pages[0].enableTransitions()

    @pages[1].setOrigin @width
    @pages[1].enableTransitions()

    @pages[2].setOrigin -1 * @width

    # load new data, decrement currentPage
    @set 'currentPage', (@get 'currentPage') - 1
    @loadData @pages[2], @tracksPerPage * (@currentPage - 2)

    @pages.unshift @pages.pop()

  swipeToTheLeft: ->
    @pages[0].setOrigin @width

    @pages[1].setOrigin -1 * @width
    @pages[1].enableTransitions()

    @pages[2].setOrigin 0
    @pages[2].enableTransitions()

    # load new data, increment currentPage
    @set 'currentPage', (@get 'currentPage') + 1
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
    return if @currentPage is 1 and delta > 0
    return if @currentPage is @pageCount and delta < 0

    page.moveTo delta for page in @pages

  bindTrackSelectionHandler: -> @$().on 'touchMouseUp', '.track', -> Shared.routeManager.set 'location', "play/#{$(this).attr 'data-track-id'}"

  unbindTrackSelectionHandler: -> @$().off 'touchMouseUp', '.track'
