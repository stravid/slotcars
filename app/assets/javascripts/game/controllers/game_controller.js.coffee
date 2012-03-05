
#= require game/controllers/car_controller
#= require game/lib/car
#= require shared/models/track_model
#= require helpers/event_normalize

namespace 'game.controllers'

game.controllers.GameController = Ember.Object.extend

  gameView: null
  carController: null
  gameLoopController: null
  isTouchMouseDown: false

  startTime: null
  endTime: null

  init: ->
    (jQuery document).on 'touchMouseDown', (event) => @onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @onTouchMouseUp event

    (jQuery @carController).on 'crossFinishLine', => @finish()
    (jQuery @gameView).on 'restartGame', => @restartGame()
    
    unless @track?
      throw new Error 'track has to be provided'

  start: ->
    @_resetTime()
    @carController.setup()
    @gameLoopController.start => @update()

  finish: ->
    @endTime = new Date().getTime()
    raceTime = @endTime - @startTime
    @gameMediator.set 'raceTime', raceTime

  update: ->
    if @isTouchMouseDown
      @carController.accelerate()
    else
      @carController.slowDown()

    @carController.drive()

  onTouchMouseDown: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = true

  onTouchMouseUp: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = false

  restartGame: ->
    @carController.reset()
    @_resetTime()

  _resetTime: ->
    @gameMediator.set 'raceTime', 0
    @startTime = new Date().getTime()
