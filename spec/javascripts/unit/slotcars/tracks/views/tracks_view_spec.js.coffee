describe 'TracksView', ->
  beforeEach ->
    @tracksView = Tracks.TracksView.create
      pageCount: 5

  describe '#onCurrentPageChange', ->
    it 'observes the currentPage attribute', ->
      sinon.spy @tracksView, 'onCurrentPageChange'
      @tracksView.set 'currentPage', 1

      (expect @tracksView.onCurrentPageChange).toHaveBeenCalled()

    it 'sets the isFirstPage attribute to true when on the first page', ->
      @tracksView.set 'currentPage', 1

      (expect @tracksView.isFirstPage).toBe true

    it 'sets the isFirstPage attribute to false when not on the first page', ->
      @tracksView.set 'currentPage', 3

      (expect @tracksView.isFirstPage).toBe false

    it 'sets the isLastPage attribute to true when on the last page', ->
      @tracksView.set 'currentPage', @tracksView.pageCount

      (expect @tracksView.isLastPage).toBe true

    it 'sets the isLastPage attribute to true when not on the last page', ->
      @tracksView.set 'currentPage', 3

      (expect @tracksView.isLastPage).toBe false

  describe '#onNextButtonClicked', ->
    it 'calls swipe with -1 to simulate a swipe to the left', ->
      sinon.stub @tracksView, 'swipe'
      @tracksView.onNextButtonClicked()

      (expect @tracksView.swipe).toHaveBeenCalled()

  describe '#onPreviousButtonClicked', ->
    it 'calls swipe with 1 to simulate a swipe to the right', ->
      sinon.stub @tracksView, 'swipe'
      @tracksView.onPreviousButtonClicked()

      (expect @tracksView.swipe).toHaveBeenCalledWith 1
