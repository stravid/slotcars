
describe 'Shared.Recordable', ->

  beforeEach ->
    @recordable = Ember.Object.extend(Shared.Recordable).create()
    @recordable._super = ->

  describe '#update', ->

    beforeEach -> sinon.stub @recordable, 'recordCarPosition'

    it 'should only record the car position if isRecording is true', ->
      @recordable.isRecording = true
      @recordable.update()
      (expect @recordable.recordCarPosition).toHaveBeenCalled()

    it 'should not record the car position if isRecording is false', ->
      @recordable.isRecording = false
      @recordable.update()
      (expect @recordable.recordCarPosition).not.toHaveBeenCalled()

  describe '#recordCarPosition', ->

    beforeEach ->
      @fakeTimer = sinon.useFakeTimers()

    afterEach ->
      @fakeTimer.restore()

    it 'should store the current data into the records array', ->
      position =
        x: 2
        y: 3
      rotation = 1
      timeSinceStart = 500

      @recordable.startTime = new Date().getTime()
      @recordable.car =
        position: position
        rotation: rotation

      @fakeTimer.tick timeSinceStart

      @recordable.recordCarPosition()

      (expect @recordable.recordedPositions[0].time).toBe timeSinceStart
      (expect @recordable.recordedPositions[0].x).toBe position.x
      (expect @recordable.recordedPositions[0].y).toBe position.y
      (expect @recordable.recordedPositions[0].rotation).toBe rotation

  describe '#restartGame', ->

    it 'should reset the records', ->
      @recordable.recordedPositions = [{}, {}]

      @recordable.restartGame()

      (expect @recordable.recordedPositions.length).toBe 0
