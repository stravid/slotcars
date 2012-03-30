
#= require slotcars/build/builder
#= require slotcars/shared/models/track
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/views/draw_view

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

  afterEach ->
    @DrawControllerMock.restore()
    @DrawViewMock.restore()

  describe 'setting up drawing editor on creation', ->

    beforeEach ->
      @TrackBackup = slotcars.shared.models.Track

      @fakeTrack = {}
      @TrackMock = slotcars.shared.models.Track =
        createRecord: sinon.stub().returns @fakeTrack

    afterEach ->
      slotcars.shared.models.Track = @TrackBackup

    it 'should create a new track model', ->
      Builder.create buildScreenView: @buildScreenViewStub
     
      (expect @TrackMock.createRecord).toHaveBeenCalled()

    it 'should create the draw controller and provide the created track', ->
      Builder.create buildScreenView: @buildScreenViewStub

      (expect @DrawControllerMock.create).toHaveBeenCalledWithAnObjectLike
        track: @fakeTrack

    it 'should create the draw view and provide the draw controller and track', ->
      Builder.create buildScreenView: @buildScreenViewStub

      (expect @DrawViewMock.create).toHaveBeenCalledWithAnObjectLike
        track: @fakeTrack
        drawController: @DrawControllerMock

    it 'should set content view property of build screen view to draw view', ->
      Builder.create buildScreenView: @buildScreenViewStub

      (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', @DrawViewMock


  describe 'destroying the builder controller', ->

    beforeEach ->
      @DrawControllerMock.destroy = sinon.spy()
      @DrawViewMock.destroy = sinon.spy()
      @builder = Builder.create buildScreenView: @buildScreenViewStub

    it 'should unset content view property of build screen view', ->
      @builder.destroy()

      (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', null

    it 'should tell the draw controller to destroy itself', ->
      @builder.destroy()

      (expect @DrawControllerMock.destroy).toHaveBeenCalled()

    it 'should tell the draw view to destroy itself', ->
      @builder.destroy()

      (expect @DrawViewMock.destroy).toHaveBeenCalled()