describe 'Shared.Panable', ->

  beforeEach ->
    @car = Shared.Car.create
      track: Shared.Track.createRecord()

    @panableMock = Ember.View.extend(Shared.Panable).create
      car: @car

  it 'should react on position changes of the car', ->
    sinon.spy @panableMock, 'onCarPositionChange'

    @car.set 'position', 1

    (expect @panableMock.onCarPositionChange).toHaveBeenCalled()
