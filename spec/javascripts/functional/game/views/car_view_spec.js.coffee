
#= require game/views/car_view

describe 'game.views.CarView (functional)', ->

  CarView = game.views.CarView

  beforeEach ->
    @carStub = Ember.Object.create
      position:
        x: 0
        y: 0

    @updateSpy = sinon.spy()

    @carView = CarView.create
      car: @carStub
      update: @updateSpy

  it 'should call update when the mediator changes', ->
    newPosition = { x: 50, y: 50 }
    @carStub.set 'position', newPosition

    (expect @updateSpy).toHaveBeenCalled()