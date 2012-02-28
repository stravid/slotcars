
#= require game/lib/movable
#= require helpers/math/vector

describe 'game.lib.Movable', ->

  Movable = game.lib.Movable
  Vector = helpers.math.Vector

  describe '#update', ->

    beforeEach ->
      @movable = Movable.create
        position: x: 0, y: 0
        speed: 1

    it 'should move object into direction with current speed', ->
      @movable.direction = Vector.create x: 1, y: 0
      @movable.update()

      (expect @movable.position).toEqual x: 1, y: 0

    it 'should calculate rotation of object', ->
      @movable.direction = Vector.create x: 0.5, y: 0.5
      @movable.update()

      (expect @movable.rotation).toBe 135

    it 'should calculate rotation of object', ->
      @movable.direction = Vector.create x: -0.5, y: 0.5
      @movable.update()

      (expect @movable.rotation).toBe 225

  describe '#accelerate', ->

    beforeEach ->
      @movable = Movable.create
        acceleration: 1
        speed: 0
        maxSpeed: 1

    it 'should add acceleration value to speed', ->
      @movable.accelerate()

      (expect @movable.speed).toBe 1

    it 'should not increase speed higher than maxSpeed', ->
      @movable.accelerate()
      @movable.accelerate()

      (expect @movable.speed).toBe 1

  describe '#decelerate', ->

    beforeEach ->
      @movable = Movable.create
        deceleration: 1
        speed: 1

    it 'should substract value from speed', ->
      @movable.decelerate()

      (expect @movable.speed).toBe 0

    it 'should not decrease speed below zero', ->
      @movable.decelerate()
      @movable.decelerate()

      (expect @movable.speed).toBe 0