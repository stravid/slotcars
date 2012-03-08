
#= require helpers/namespace
#= require slotcars/play/lib/car

namespace 'slotcars.play.controllers'

Car = slotcars.play.lib.Car

slotcars.play.controllers.PlayController = Ember.Object.extend

  playScreenView: null
  track: null

  init: ->
    @car = Car.create
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100