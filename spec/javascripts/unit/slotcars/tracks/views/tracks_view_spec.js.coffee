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

  describe '#onKeyDown', ->
    beforeEach ->
      Ember.run => @tracksView.appendTo jQuery '<div>'
      sinon.spy @tracksView, 'onKeyDown'

    it 'should have bound the key down event listener', ->
      (jQuery document).trigger 'keydown'

      (expect @tracksView.onKeyDown).toHaveBeenCalled()

    describe 'when key is left arrow key', ->
      beforeEach ->
        @keyEvent = keyCode: 37 # key code for left arrow
        sinon.stub @tracksView, 'onPreviousButtonClicked'

      it 'should call the action for the previous button', ->
        @tracksView.onKeyDown @keyEvent

        (expect @tracksView.onPreviousButtonClicked).toHaveBeenCalled()

    describe 'when key is right arrow key', ->
      beforeEach ->
        @keyEvent = keyCode: 39 # key code for right arrow
        sinon.stub @tracksView, 'onNextButtonClicked'

      it 'should call the action for the next button', ->
        @tracksView.onKeyDown @keyEvent

        (expect @tracksView.onNextButtonClicked).toHaveBeenCalled()

  describe '#willDestroy', ->
    beforeEach ->
      Ember.run => @tracksView.appendTo jQuery '<div>'

    it 'should unbind the keydown event listener', ->
      sinon.spy @tracksView, 'onKeyDown'
      @tracksView.willDestroy()

      (jQuery document).trigger 'keydown'

      (expect @tracksView.onKeyDown).not.toHaveBeenCalled()
