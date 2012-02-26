
#= require game/views/car_view

describe 'game.views.CarView (functional)', ->

  CarView = game.views.CarView

  beforeEach ->
    @carMediatorStub = Ember.Object.create
      position:
        x: 0
        y: 0

    @paperStub =
      rect: sinon.stub().returns
        attr: sinon.spy()

    @carView = CarView.create
      carMediator: @carMediatorStub
      paper: @paperStub

  it 'should create a car rectangle with a given position when created', ->
    position = @carMediatorStub.get 'position'

    (expect @paperStub.rect).toHaveBeenCalledWith position.x, position.y, (@carView.get 'width'), (@carView.get 'height')

  it 'should update the car position when the position on the mediator changes', ->
    newPosition = { x: 50, y: 50 }
    @carMediatorStub.set 'position', newPosition

    (expect (@carView.get 'car').attr).toHaveBeenCalledWith newPosition