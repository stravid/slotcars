
describe 'Shared.Recordable', ->

  beforeEach -> 
    @recordable = Ember.Object.extend(Shared.Recordable).create()
    @recordable._super = ->

  describe '#update', ->

    it 'should only record the car position if the controls are enabled', ->
      sinon.stub @recordable, 'recordCarPosition'

      @recordable.carControlsEnabled = false
      @recordable.update()
      (expect @recordable.recordCarPosition).not.toHaveBeenCalled()

      @recordable.carControlsEnabled = true
      @recordable.update()
      (expect @recordable.recordCarPosition).toHaveBeenCalled()

  describe '#recordCarPosition', ->

    it 'should store the current data into the records array', ->
      raceTime = 10
      position =
        x: 2
        y: 3
      rotation = 1

      @recordable.raceTime = raceTime
      @recordable.car =
        position: position
        rotation: rotation

      @recordable.recordCarPosition()

      (expect @recordable.records[0].time).toBe raceTime
      (expect @recordable.records[0].x).toBe position.x
      (expect @recordable.records[0].y).toBe position.y
      (expect @recordable.records[0].rotation).toBe rotation

  describe '#restartGame', ->

    it 'should reset the records', ->
      @recordable.records = [{}, {}]

      @recordable.restartGame()

      (expect @recordable.records.length).toBe 0
