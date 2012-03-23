
#= require slotcars/shared/lib/movable

describe 'slotcars.shared.lib.Movable', ->

  Movable = slotcars.shared.lib.Movable

  beforeEach ->
    @movable = Ember.Object.extend(Movable).create() # because a mixin has no 'create' method
    
  describe 'move to a position', ->

    it 'should update its position', ->
      position = { x: 3, y: 2 }
      @movable.moveTo position

      (expect @movable.position).toEqual position

    it 'should update its rotation', ->
      @movable.position = { x: 0, y: 0 }
      @movable.moveTo {x: 3, y: 4}, {x: 2, y: 4}

      (expect @movable.rotation).not.toBe 0
      
  describe 'reset bounce', ->

    it 'should reset all values fro drift', ->
      @movable.resetMovable()
      
      (expect @movable.bouncePosition).toBe null
      (expect @movable.oldTailPosition).toBe null
