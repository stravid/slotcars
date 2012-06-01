Shared.Recordable = Ember.Mixin.create

  car: Ember.required()
  isRaceFinished: Ember.required()
  raceTime: Ember.required()

  recordedPositions: []
  isRecording: false

  update: ->
    @_super()

    @recordCarPosition() if @isRecording

    if @isRaceFinished and @car.speed is 0 and @isRecording
      @set 'isRecording', false

  recordCarPosition: ->
    @recordedPositions.push
      x: parseInt @car.position.x, 10
      y: parseInt @car.position.y, 10
      rotation: parseInt @car.rotation, 10
      time: new Date().getTime() - @startTime

  restartGame: ->
    @_super()

    @recordedPositions = []
    @set 'isRecording', false

  startRace: ->
    @_super()

    @set 'isRecording', true
