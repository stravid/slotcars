
#= require slotcars/play/play_screen
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track_model
#= require slotcars/play/controllers/play_controller

describe 'play screen', ->

  PlayScreen = slotcars.play.PlayScreen
  PlayScreenView = slotcars.play.views.PlayScreenView
  PlayScreenStateManager = slotcars.play.PlayScreenStateManager
  TrackModel = slotcars.shared.models.TrackModel
  PlayController = slotcars.play.controllers.PlayController

  beforeEach ->
    @playScreenViewMock = mockEmberClass PlayScreenView, append: sinon.spy()
    @playScreenStateManagerMock = mockEmberClass PlayScreenStateManager, send: sinon.spy()
    @PlayController = mockEmberClass PlayController
    @playScreen = PlayScreen.create()

  afterEach ->
    @playScreenViewMock.restore()
    @playScreenStateManagerMock.restore()
    @PlayController.restore()

  describe 'append to application', ->

    beforeEach ->
      @playScreen.load = sinon.spy()

    it 'should create the play screen state manager', ->
      @playScreen.appendToApplication()

      (expect @playScreenStateManagerMock.create).toHaveBeenCalled()

    it 'should append the play screen view to the DOM', ->
      @playScreen.appendToApplication()

      (expect @playScreenViewMock.append).toHaveBeenCalled()

  describe 'load', ->

    beforeEach ->
      @playScreen.appendToApplication()

    it 'should load a track', ->
      @playScreen.load()

      (expect @playScreen.track).toBeInstanceOf TrackModel

    it 'should send loaded to the play screen state manager', ->
      @playScreen.load()

      (expect @playScreenStateManagerMock.send).toHaveBeenCalledWith 'loaded'

  describe 'initialize', ->

    it 'should create play controller and provide play screen view', ->
      @playScreen.appendToApplication()
      @playScreen.initialize()

      (expect @PlayController.create).toHaveBeenCalledWithAnObjectLike playScreenView: @playScreenViewMock

  describe 'destroy', ->

    beforeEach ->
      @playScreenViewMock.remove = sinon.spy()
      @playScreen.appendToApplication()

    it 'should tell the play screen view to remove itself', ->
      @playScreen.destroy()

      (expect @playScreenViewMock.remove).toHaveBeenCalled()