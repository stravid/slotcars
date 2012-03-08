
#= require slotcars/play/controllers/play_controller
#= require slotcars/play/lib/car

describe 'play controller', ->

  PlayController = slotcars.play.controllers.PlayController
  Car = slotcars.play.lib.Car

  beforeEach ->
    @CarMock = mockEmberClass Car

  afterEach ->
    @CarMock.restore()

  it 'should extend Ember.Object', ->
    (expect PlayController).toExtend Ember.Object

  it 'should create a car', ->
    PlayController.create
      playScreenView: {}
      track: {}

    (expect @CarMock.create).toHaveBeenCalled()
