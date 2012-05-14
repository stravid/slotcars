
describe 'Shared.Drivable', ->

  beforeEach -> @drivable = Ember.Object.extend(Shared.Drivable).create()


  describe 'accelerating', ->

    it 'should accelerate if called with true', ->
      @drivable.set 'acceleration', 1
      @drivable.set 'maxSpeed', 1

      @drivable.accelerate true

      (expect @drivable.speed).toBe @drivable.acceleration

    it 'should decelerate if called with false', ->
      @drivable.set 'speed', 1
      @drivable.set 'deceleration', 1

      @drivable.accelerate false

      (expect @drivable.speed).toBe 0


  describe 'clamping to max speed', ->

    it 'should clamp speed to max speed when accelerating', ->
      @drivable.set 'acceleration', 2
      @drivable.set 'maxSpeed', 1

      @drivable.accelerate true

      (expect @drivable.speed).toBe @drivable.maxSpeed


  describe 'clamping to min speed', ->

    it 'should clamp speed to min speed when decelerating', ->
      @drivable.set 'speed', 1
      @drivable.set 'deceleration', 2

      @drivable.accelerate false

      (expect @drivable.speed).toBe 0