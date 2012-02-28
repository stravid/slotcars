
#= require game/lib/car
#= require game/lib/movable

#= require helpers/math/vector

describe 'game.lib.Car', ->

  Car = game.lib.Car
  Movable = game.lib.Movable
  Vector = helpers.math.Vector

  it 'should extend Movable', ->
    (expect Movable.detect Car).toBe true

  it 'should have isCrashing set to false', ->
    car = Car.create()
    (expect car.isCrashing).toBe false

  describe '#checkForCrash', ->

    beforeEach ->
      @car = Car.create speed: 1


    it 'should not crash if there is no previousDirection', ->
      @car.checkForCrash()

      (expect @car.isCrashing).toBe false


    it 'should set crashing to true when too fast in curve', ->
      @car.traction = 89 # loses vs. speed * angle || 1 * 90 = 90
      @car.previousDirection = Vector.create x: 1, y: 0
      @car.direction = Vector.create x: 0, y: 1

      @car.checkForCrash()

      (expect @car.isCrashing).toBe true

    it 'should not set crashing when traction is high enough', ->
      @car.traction = 90 # wins vs. speed * angle || 1 * 90 = 90
      @car.previousDirection = Vector.create x: 1, y: 0
      @car.direction = Vector.create x: 0, y: 1

      @car.checkForCrash()

      (expect @car.isCrashing).toBe false

  describe '#driveInDirection', ->

    beforeEach ->
      @updateStub = sinon.spy()
      @direction = Vector.create x: 1, y: 1

      @car = Car.create
        direction: @direction
        update: @updateStub

      @newDirection = Vector.create x: 0, y: -1
      @car.driveInDirection @newDirection

    it 'should call #update', ->
      (expect @updateStub).toHaveBeenCalled()

    it 'should set the previous direction to the last driven direction', ->
      (expect @car.previousDirection).toEqual @direction

    it 'should set the current direction to given direction', ->
      (expect @car.direction).toEqual @newDirection
