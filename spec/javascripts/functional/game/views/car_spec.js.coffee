
describe 'game.views.CarView (functional)', ->

  CarView = game.views.CarView

  beforeEach ->
    @mediatorStub = Ember.Object.create
      position:
        x: 0
        y: 0

    @paperStub =
      rect: sinon.stub().returns { attr: sinon.spy() }

  it 'should create a car rectangle when created', ->
    CarView.create
      mediator: @mediatorStub
      paper: @paperStub

    (expect @paperStub.rect).toHaveBeenCalled()

  it 'should update the car position when the position on the mediator changes', ->
    carView = CarView.create
      mediator: @mediatorStub
      paper: @paperStub

    newPosition = { x: 50, y: 50 }

    @mediatorStub.set 'position', newPosition

    (expect carView.get('car').attr).toHaveBeenCalledWith newPosition