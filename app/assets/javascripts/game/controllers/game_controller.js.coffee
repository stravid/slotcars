
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

  startTime: null
  endTime: null
  raceTime: null

  init: ->
    ($ document).on 'touchMouseDown', => @onTouchMouseDown()
    ($ document).on 'touchMouseUp', => @onTouchMouseUp()

  start: ->
    @raceTime = null
    @startTime = new Date().getTime()
    @gameLoopController.start => @update()

  finish: ->
    @endTime = new Date().getTime()
    @raceTime = @endTime - @startTime
    @mediator.set 'raceTime', @raceTime

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
