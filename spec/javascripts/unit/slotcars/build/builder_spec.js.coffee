
#= require slotcars/build/builder

describe 'builder', ->

  Builder = slotcars.build.Builder
  DrawController = slotcars.build.controllers.DrawController
  DrawView = slotcars.build.views.DrawView

  it 'should extend Ember.Object', ->
    (expect Builder).toExtend Ember.Object

  beforeEach ->
    @DrawControllerMock = mockEmberClass DrawController
    @DrawViewMock = mockEmberClass DrawView

    @buildScreenViewStub = set: sinon.spy()
    @stateManagerStub = {}
    @fakeTrack = {}

    @builder = Builder.create
      stateManager: @stateManagerStub
      buildScreenView: @buildScreenViewStub
      track: @fakeTrack

  afterEach ->
    @DrawControllerMock.restore()
    @DrawViewMock.restore()

  describe 'setting up drawing editor on creation', ->

    it 'should create the draw controller and provide the created track', ->
      (expect @DrawControllerMock.create).toHaveBeenCalledWithAnObjectLike
        stateManager: @stateManagerStub
        track: @fakeTrack

    it 'should create the draw view and provide the draw controller and track', ->
      (expect @DrawViewMock.create).toHaveBeenCalledWithAnObjectLike
        track: @fakeTrack
        drawController: @DrawControllerMock

    it 'should set content view property of build screen view to draw view', ->
      (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', @DrawViewMock

  describe 'destroying dependencies', ->

    beforeEach ->
      @DrawControllerMock.destroy = sinon.spy()
      @DrawViewMock.destroy = sinon.spy()

    it 'should unset content view property of build screen view', ->
      @builder.destroy()

      (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', null

    it 'should tell the draw controller to destroy itself', ->
      @builder.destroy()

      (expect @DrawControllerMock.destroy).toHaveBeenCalled()

    it 'should tell the draw view to destroy itself', ->
      @builder.destroy()

      (expect @DrawViewMock.destroy).toHaveBeenCalled()
