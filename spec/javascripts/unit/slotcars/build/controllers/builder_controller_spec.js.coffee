
#= require slotcars/build/controllers/builder_controller
#= require slotcars/shared/models/track_model
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/views/draw_view

describe 'builder controller', ->

  BuilderController = slotcars.build.controllers.BuilderController
  DrawController = slotcars.build.controllers.DrawController
  DrawView = slotcars.build.views.DrawView

  it 'should extend Ember.Object', ->
    (expect BuilderController).toExtend Ember.Object

  beforeEach ->
    @DrawControllerMock = mockEmberClass DrawController
    @DrawViewMock = mockEmberClass DrawView
    @buildScreenViewStub = set: sinon.spy()

  afterEach ->
    @DrawControllerMock.restore()
    @DrawViewMock.restore()


  describe 'setting up drawing editor on creation', ->

    beforeEach ->
      @TrackModelBackup = slotcars.shared.models.TrackModel

      @fakeTrackModel = {}
      @TrackModelMock = slotcars.shared.models.TrackModel =
        createRecord: sinon.stub().returns @fakeTrackModel

    afterEach ->
      slotcars.shared.models.TrackModel = @TrackModelBackup


    it 'should create a new track model', ->
      BuilderController.create buildScreenView: @buildScreenViewStub

      (expect @TrackModelMock.createRecord).toHaveBeenCalled()

    it 'should create the draw controller and provide the created track', ->
      BuilderController.create buildScreenView: @buildScreenViewStub

      (expect @DrawControllerMock.create).toHaveBeenCalledWithAnObjectLike
        track: @fakeTrackModel

    it 'should create the draw view and provide the draw controller and track', ->
      BuilderController.create buildScreenView: @buildScreenViewStub

      (expect @DrawViewMock.create).toHaveBeenCalledWithAnObjectLike
        track: @fakeTrackModel
        drawController: @DrawControllerMock

    it 'should set content view property of build screen view to draw view', ->
      BuilderController.create buildScreenView: @buildScreenViewStub

      (expect @buildScreenViewStub.set).toHaveBeenCalledWith 'contentView', @DrawViewMock


  describe 'destroying the builder controller', ->

    beforeEach ->
      @DrawControllerMock.destroy = sinon.spy()
      @DrawViewMock.remove = sinon.spy()
      @builderController = BuilderController.create buildScreenView: @buildScreenViewStub


    it 'should tell the draw controller to destroy itself', ->
      @builderController.destroy()

      (expect @DrawControllerMock.destroy).toHaveBeenCalled()

    it 'should tell the draw view to remove itself', ->
      @builderController.destroy()

      (expect @DrawViewMock.remove).toHaveBeenCalled()