Shared.Recordable = Ember.Mixin.create

  car: Ember.required()
  carControlsEnabled: Ember.required()
  raceTime: Ember.required()

  records: []

  update: ->
    @_super()

    @recordCarPosition() if @carControlsEnabled

  recordCarPosition: ->
    @records.push
      x: parseInt @car.position.x, 10
      y: parseInt @car.position.y, 10
      rotation: parseInt @car.rotation, 10
      time: @raceTime

  restartGame: ->
    @_super()

    @records = []