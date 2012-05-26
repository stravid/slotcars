
describe 'Shared.Recordable', ->

  beforeEach -> 
    @recordable = Ember.Object.extend(Shared.Recordable).create()
    @recordable._super = ->

  describe '#update', ->

    beforeEach -> sinon.stub @recordable, 'recordCarPosition'

    it 'should only record the car position if the controls are enabled', ->
      @recordable.isRaceRunning = true
      @recordable.update()
      (expect @recordable.recordCarPosition).toHaveBeenCalled()

    it 'should not record the car position if the controls are disabled', ->
      @recordable.isRaceRunning = false
      @recordable.update()
      (expect @recordable.recordCarPosition).not.toHaveBeenCalled()


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

      (expect @recordable.recordedPositions[0].time).toBe raceTime
      (expect @recordable.recordedPositions[0].x).toBe position.x
      (expect @recordable.recordedPositions[0].y).toBe position.y
      (expect @recordable.recordedPositions[0].rotation).toBe rotation

  describe '#restartGame', ->

    it 'should reset the records', ->
      @recordable.recordedPositions = [{}, {}]

      @recordable.restartGame()

      (expect @recordable.recordedPositions.length).toBe 0
