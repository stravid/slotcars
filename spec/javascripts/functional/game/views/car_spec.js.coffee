
describe 'game.views.CarView (functional)', ->

  CarView = game.views.CarView

  beforeEach ->
    @mediatorStub = Ember.Object.create
      position:
        x: 0
        y: 0

    @paperStub =
      rect: sinon.stub().returns { attr: sinon.spy() }    

  it 'should create a car rectangle with a given position when created', ->
    carView = CarView.create
      mediator: @mediatorStub
      paper: @paperStub
    
    position = @mediatorStub.get 'position'

    (expect @paperStub.rect).toHaveBeenCalledWith position.x, position.y, (carView.get 'width'), (carView.get 'height')

  it 'should update the car position when the position on the mediator changes', ->
    carView = CarView.create
      mediator: @mediatorStub
      paper: @paperStub

    newPosition = { x: 50, y: 50 }
    @mediatorStub.set 'position', newPosition

    (expect (carView.get 'car').attr).toHaveBeenCalledWith newPosition