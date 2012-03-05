
#= require game/controllers/car_controller
#= require game/lib/car
#= require shared/models/track_model

#= require game/views/car_view

#= require helpers/event_normalize

namespace 'game.controllers'

Car = game.lib.Car
CarView = game.views.CarView

game.controllers.GameController = Ember.Object.extend

  gameView: null
  car: null
  gameLoopController: null
  isTouchMouseDown: false

  startTime: null
  endTime: null

  init: ->
    (jQuery document).on 'touchMouseDown', (event) => @onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @onTouchMouseUp event

    (jQuery @car).on 'crossFinishLine', => @finish()
#    (jQuery @gameView).on 'restartGame', => @restartGame()
    
    @car = Car.create()
    @carView = CarView.create
      car: @car

    @carView.appendTo '#game-application'

    @_super()


    unless @track?
      throw new Error 'track has to be provided'

  start: ->
    @_resetTime()
    position = @track.getPointAtLength 0
    @car.moveTo { x: position.x, y: position.y }

    @gameLoopController.start => @update()

  finish: ->
    @endTime = new Date().getTime()
    raceTime = @endTime - @startTime
    @gameMediator.set 'raceTime', raceTime

  update: ->
    if @isTouchMouseDown
      @car.accelerate()
    else
      @car.decelerate()

    #@car.moveTo()

  onTouchMouseDown: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = true

  onTouchMouseUp: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = false

  restartGame: ->
    @car.reset()
    @_resetTime()

  _resetTime: ->
    @startTime = new Date().getTime()
