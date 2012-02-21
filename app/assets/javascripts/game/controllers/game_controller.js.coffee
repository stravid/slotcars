
#= require vendor/raphael

#= require game/mediators/track
#= require game/views/track

#= require game/mediators/car_mediator
#= require game/views/car
#= require game/controllers/car_controller

#= require helpers/event_normalize

namespace 'game.controllers'

@game.controllers.GameController = Ember.Object.extend

  carController: null
  gameLoopController: null
  isTouchMouseDown: false

  init: ->
    ($ document).on 'touchMouseDown', $.proxy @onTouchMouseDown, this
    ($ document).on 'touchMouseUp', $.proxy @onTouchMouseUp, this

  start: ->
    (@gameLoopController.start $.proxy @update, this)

  update: ->
    if @isTouchMouseDown
      @carController.accelerate()
    else
      @carController.slowDown()

    @carController.drive()

  onTouchMouseDown: ->
    @isTouchMouseDown = true

  onTouchMouseUp: ->
    @isTouchMouseDown = false

