
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


  describe '#crash', ->

    beforeEach ->
      @updateStub = sinon.spy()
      @decelerateStub = sinon.spy()

      @car = Car.create
        update: @updateStub
        decelerate: @decelerateStub

    it 'should end crashing when speed is zero', ->
      @car.isCrashing = true
      @car.speed = 0
      @car.crash()

      (expect @car.isCrashing).toBe false

    it 'should continue crashing as long as speed is bigger than zero', ->
      @car.isCrashing = true
      @car.speed = 1
      @car.crash()

      (expect @car.isCrashing).toBe true

    it 'should call #decelerate', ->
      @car.crash()

      (expect @decelerateStub).toHaveBeenCalled()

    it 'should call #update', ->
      @car.crash()

      (expect @updateStub).toHaveBeenCalled()


  describe '#decelerate', ->

    beforeEach ->
      @car = Car.create
        offRoadDeceleration: 3
        deceleration: 4
        speed: 5

    it 'should decelerate with standard deceleration when car is on track', ->
      @car.decelerate()

      (expect @car.speed).toBe 1

    it 'should decelerate with offRoadDeceleration when car is crashing', ->
      @car.isCrashing = true
      @car.decelerate()

      (expect @car.speed).toBe 2

    it 'should not let speed get below zero after crashing', ->
      @car.isCrashing = true
      @car.offRoadDeceleration = 8
      @car.decelerate()

      (expect @car.speed).toBe 0
