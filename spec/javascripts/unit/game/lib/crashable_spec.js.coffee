
#= require game/lib/crashable
#= require helpers/math/vector

describe 'game.lib.Crashable', ->

  Crashable = game.lib.Crashable
  Vector = helpers.math.Vector

  beforeEach ->
    @crashable = Ember.Object.extend(Crashable).create()

  it 'should initially not be in crashing state', ->
    (expect @crashable.isCrashing).toBe false


  describe 'consider wether to crash', ->

    describe 'when previous direction does not exist', ->
    
      it 'should not crash', ->
        position = { x: (Math.round Math.random()), y: (Math.round Math.random()) }
        @crashable.checkForCrash position

        (expect @crashable.isCrashing).toBe false

    describe 'when previous direction exists', ->

      beforeEach ->
        @crashable.position = { x: 0, y: 0 }
        @crashable.previousDirection = Vector.create x: 1, y: 0

      it 'should crash if traction is not high enough', ->
        @crashable.traction = 89 # is less than (speed * angle)
        @crashable.speed = 1

        @crashable.checkForCrash { x: 0, y: 1 }

        (expect @crashable.isCrashing).toBe true

      it 'should not crash if traction is high enough', ->
        @crashable.traction = 90 # equals (speed * angle) - equals upper limit
        @crashable.speed = 1

        @crashable.checkForCrash { x: 0, y: 1 }

        (expect @crashable.isCrashing).toBe false

      it 'should save current direction for further calculations', ->
        @crashable.position = { x: 0, y: 0 }
        nextPosition = { x: 0, y: 1 }
        
        @crashable.checkForCrash nextPosition
        direction = Vector.create from: @crashable.position, to: nextPosition

        (expect @crashable.previousDirection).toEqual direction

  describe 'crashing', ->

    beforeEach ->
        @decelerateStub = sinon.spy()
        @crashable.crashcelerate = @decelerateStub

    describe 'when speed is zero', ->

      it 'should end crashing', ->
        @crashable.isCrashing = true
        @crashable.speed = 0
        @crashable.crash()

        (expect @crashable.isCrashing).toBe false

    describe 'when speed is bigger than zero', ->

      it 'should continue crashing', ->
        @crashable.isCrashing = true
        @crashable.speed = 1
        @crashable.crash()

        (expect @crashable.isCrashing).toBe true

      it 'should decelerate', ->
        @crashable.crash()

        (expect @decelerateStub).toHaveBeenCalled()