describe 'Build.Editor', ->

  beforeEach ->
    @EditViewMock = mockEmberClass Build.EditView
    @fakeTrack = {}
    @buildScreenViewStub = set: sinon.spy()

    @editor = Build.Editor.create
      buildScreenView: @buildScreenViewStub
      track: @fakeTrack

  afterEach ->
    @EditViewMock.restore()

  it 'should create a edit view and pass dependencies', ->
    (expect @EditViewMock.create).toHaveBeenCalledWith track: @fakeTrack

  it 'should set content view property of build screen view to edit view', ->
    (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', @EditViewMock

  describe 'destroying', ->

    beforeEach ->
      @EditViewMock.destroy = sinon.spy()

    it 'should unset content view property of build screen view', ->
      @editor.destroy()

      (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', null

    it 'should tell the edit view to destroy itself', ->
      @editor.destroy()

      (expect @EditViewMock.destroy).toHaveBeenCalled()
