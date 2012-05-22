Shared.Recordable = Ember.Mixin.create

  car: Ember.required()
  carControlsEnabled: Ember.required()
  raceTime: Ember.required()

  recordedPositions: []

  update: ->
    @_super()

    @recordCarPosition() if @carControlsEnabled

  recordCarPosition: ->
    @recordedPositions.push
      x: parseInt @car.position.x, 10
      y: parseInt @car.position.y, 10
      rotation: parseInt @car.rotation, 10
      time: @raceTime

  restartGame: ->
    @_super()

    @recordedPositions = []