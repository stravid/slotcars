
#= require slotcars/build/test_drive
#= require slotcars/shared/models/car
#= require slotcars/shared/models/track
#= require slotcars/shared/controllers/base_game_controller

#= require slotcars/play/views/car_view
#= require slotcars/shared/views/track_view

describe 'test drive', ->

  TestDrive = Slotcars.build.TestDrive
  Car = slotcars.shared.models.Car
  Track = slotcars.shared.models.Track
  BaseGameController = Slotcars.shared.controllers.BaseGameController
  CarView = slotcars.play.views.CarView
  TrackView = slotcars.shared.views.TrackView

  beforeEach ->
    @carMock = mockEmberClass Car
    @trackMock = mockEmberClass Track

    @BaseGameControllerMock = mockEmberClass BaseGameController
    @TestTrackViewMock = mockEmberClass TrackView, gameController: {}
    @CarViewMock = mockEmberClass CarView

    @buildScreenViewMock =
      set: sinon.spy()

    @testDrive = TestDrive.create
      buildScreenView: @buildScreenViewMock
      car: @carMock
      track: @trackMock

  afterEach ->
    @carMock.restore()
    @trackMock.restore()
    @BaseGameControllerMock.restore()
    @TestTrackViewMock.restore()
    @CarViewMock.restore()

  it 'should extend Ember.Object', ->
    (expect TestDrive).toExtend Ember.Object

  it 'should create a car view and provide a car', ->
    (expect @CarViewMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock

  it 'should create a game controller and provide necessary dependencies', ->
    (expect @BaseGameControllerMock.create).toHaveBeenCalledWithAnObjectLike car: @carMock, track: @trackMock

  it 'should create a track view and provide dependencies', ->
    (expect @TestTrackViewMock.create).toHaveBeenCalledWithAnObjectLike gameController: @BaseGameControllerMock, track: @trackMock

  it 'should append car view to play screen view', ->
    (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'carView', @CarViewMock

  it 'should append track view to play screen view', ->
    (expect @buildScreenViewMock.set).toHaveBeenCalledWith 'contentView', @TestTrackViewMock

  describe 'starting the game', ->

    beforeEach ->
      @BaseGameControllerMock.start = sinon.spy()

    it 'should start the game controller', ->
      @testDrive.start()

      (expect @BaseGameControllerMock.start).toHaveBeenCalled()

  describe 'destroying the game', ->

    beforeEach ->
      @BaseGameControllerMock.destroy = sinon.spy()

    it 'should call destroy on the game controller', ->
      @testDrive.destroy()

      (expect @BaseGameControllerMock.destroy).toHaveBeenCalled()
