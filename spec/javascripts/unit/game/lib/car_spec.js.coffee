
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


  describe 'defaults on creation', ->

    beforeEach ->
      @car = Car.create()

    it 'should set speed to zero', ->
      (expect @car.speed).toBe 0

    it 'should set lengthAtTrack', ->
      (expect @car.lengthAtTrack).toBe 0

    it 'should set crashing to false', ->
      (expect @car.isCrashing).toBe false


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


  describe '#crashcelerate', ->

    beforeEach ->
      @car = Car.create
        crashDeceleration: 3
        speed: 5

    it 'should decelerate with crashDeceleration', ->
      @car.crashcelerate()

      (expect @car.speed).toBe 2

    it 'should not let speed get below zero after crashing', ->
      @car.crashDeceleration = 8
      @car.crashcelerate()

      (expect @car.speed).toBe 0


  describe '#reset', ->

    beforeEach ->
      @car = Car.create
        speed: 10
        lengthAtTrack: 293

    it 'should reset speed', ->
      @car.reset()

      (expect @car.speed).toEqual 0

    it 'should reset lengthAtTrack', ->
      @car.reset()

      (expect @car.lengthAtTrack).toEqual 0

  describe '#drive', ->

    beforeEach ->
      @car = Car.create
        speed: 1

    it 'should update lengthAtTrack', ->
      @car.drive()

      (expect @car.lengthAtTrack).toBe 1

