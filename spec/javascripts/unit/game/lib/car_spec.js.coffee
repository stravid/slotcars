
#= require game/lib/car
#= require game/lib/movable
#= require game/lib/crashable

#= require helpers/math/vector

describe 'game.lib.Car', ->

  Car = game.lib.Car
  Vector = helpers.math.Vector
  Movable = game.lib.Movable
  Crashable = game.lib.Crashable

  describe 'useage of mixins', ->

    beforeEach ->
      @car = Car.create()

    it 'should use Movable', ->
      (expect Movable.detect @car).toBe true

    it 'should use Crashable', ->
      (expect Crashable.detect @car).toBe true


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


  describe '#accelerate', ->

    beforeEach ->
      @car = Car.create
        acceleration: 1
        speed: 0
        maxSpeed: 1

    it 'should add acceleration value to speed', ->
      @car.accelerate()

      (expect @car.speed).toBe 1

    it 'should not increase speed higher than maxSpeed', ->
      @car.accelerate()
      @car.accelerate()

      (expect @car.speed).toBe 1


  describe '#decelerate', ->

    beforeEach ->
      @car = Car.create
        crashDeceleration: 3
        deceleration: 4
        speed: 5

    it 'should decelerate with standard deceleration when car is on track', ->
      @car.decelerate()

      (expect @car.speed).toBe 1

    it 'should not decrease speed below zero', ->
      @car.decelerate()
      @car.decelerate()

      (expect @car.speed).toBe 0


    it 'should decelerate with crashDeceleration when car is crashing', ->
      @car.isCrashing = true
      @car.decelerate()

      (expect @car.speed).toBe 2

    it 'should not let speed get below zero after crashing', ->
      @car.isCrashing = true
      @car.crashDeceleration = 8
      @car.decelerate()

      (expect @car.speed).toBe 0
