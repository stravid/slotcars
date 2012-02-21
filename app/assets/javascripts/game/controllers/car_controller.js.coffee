
#= require helpers/namespace

namespace 'game.controllers'

@game.controllers.CarController = Ember.Object.extend

  speed: 0
  lengthAtTrack: 0

  setTrackPath: ->
    @lengthAtTrack = 0