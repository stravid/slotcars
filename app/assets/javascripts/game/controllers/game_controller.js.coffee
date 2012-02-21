
#= require vendor/raphael

#= require game/mediators/track
#= require game/views/track

#= require game/mediators/car_mediator
#= require game/views/car
#= require game/controllers/car_controller

namespace 'game.controllers'

@game.controllers.GameController = Ember.Object.extend

  carController: null
