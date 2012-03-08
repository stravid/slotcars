
#= require game/controllers/game_loop_controller

#= require slotcars/play/lib/car
#= require shared/models/track_model

#= require game/views/car_view

#= require helpers/event_normalize

namespace 'game.controllers'

Car = slotcars.play.lib.Car
CarView = game.views.CarView

game.controllers.GameController = Ember.Object.extend

  gameView: null
  car: null
  gameLoopController: null
  isTouchMouseDown: false

  startTime: null
  endTime: null

  init: ->
    @gameLoopController = game.controllers.GameLoopController.create()

    @car = Car.create
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    offset = (jQuery '#game-application').offset()
    @carView = CarView.create
      car: @car
      offset: offset

    @carView.appendTo '#game-application'

    (jQuery document).on 'touchMouseDown', (event) => @onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @onTouchMouseUp event

    (jQuery @gameView).on 'restartGame', => @restartGame()

    unless @track?
      throw new Error 'track has to be provided'

  start: ->
    @_resetTime()
    startPosition = @track.getPointAtLength 0
    @car.moveTo { x: startPosition.x, y: startPosition.y }

    @car.jumpstart()
    @car.reset()

    (jQuery @car).on 'crossFinishLine', => @finish()
    @gameLoopController.start => @update()

  finish: ->
    (jQuery @car).off 'crossFinishLine'
    @endTime = new Date().getTime()
    @set 'raceTime', @endTime - @startTime
    @car.reset()

  update: ->
    unless @car.isCrashing
      if @isTouchMouseDown
        @car.accelerate()
      else
        @car.decelerate()
  
      newLengthAtTrack = (@car.get 'lengthAtTrack') + (@car.get 'speed')
      nextPosition = @track.getPointAtLength newLengthAtTrack

      @car.checkForCrash nextPosition # isCrashing can be modified inside

    if @car.isCrashing
      @car.crashcelerate()
      @car.crash()
    else
      @car.drive()      # automatically handles 'respawn'
      @car.jumpstart()  # cares for right orientation
      @car.moveTo { x: nextPosition.x, y: nextPosition.y }

      if (@car.get 'lengthAtTrack') > (@track.get 'totalLength')
        (jQuery @car).trigger 'crossFinishLine'


  onTouchMouseDown: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = true

  onTouchMouseUp: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = false

  restartGame: ->
    @car.reset()
    @_resetTime()

    position = @track.getPointAtLength 0
    @car.moveTo { x: position.x, y: position.y }

    (jQuery @car).on 'crossFinishLine', => @finish()

  _resetTime: ->
    @set 'raceTime', 0
    @startTime = new Date().getTime()
