
#= require vendor/raphael

#= require game/mediators/track
#= require game/views/track

#= require game/mediators/car_mediator
#= require game/views/car
#= require game/controllers/car_controller

#= require helpers/event_normalize

namespace 'game.controllers'

@game.controllers.GameController = Ember.Object.extend

  #gameView: null
  mediator: null
  carController: null
  gameLoopController: null
  isTouchMouseDown: false

  startTime: null
  endTime: null
  raceTime: null

  init: ->
    (jQuery document).on 'touchMouseDown', => @onTouchMouseDown()
    (jQuery document).on 'touchMouseUp', => @onTouchMouseUp()
    
    (jQuery @carController).on 'crossFinishLine', => @finish()
    #(jQuery @gameView).on 'startGame', => @start()

  start: ->
    #@mediator.set 'raceTime', 0
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
