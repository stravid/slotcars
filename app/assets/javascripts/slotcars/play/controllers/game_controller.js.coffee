
#= require slotcars/play/controllers/game_loop_controller
#= require slotcars/shared/models/car
#= require slotcars/shared/models/track_model
#= require slotcars/play/views/car_view

#= require helpers/event_normalize

namespace 'slotcars.play.controllers'

Car = slotcars.shared.models.Car
CarView = slotcars.play.views.CarView
GameLoopController = slotcars.play.controllers.GameLoopController

slotcars.play.controllers.GameController = Ember.Object.extend

  car: null
  track: null
  gameLoopController: null
  isTouchMouseDown: false

  startTime: null
  endTime: null
  raceTime: null

  init: ->
    @gameLoopController = GameLoopController.create()

    (jQuery document).on 'touchMouseDown', (event) => @onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @onTouchMouseUp event

    unless @track?
      throw new Error 'track has to be provided'
    unless @car?
      throw new Error 'car has to be provided'

  start: ->
    @_resetTime()
    @_resetCarPosition()

    @car.jumpstart()
    @car.reset()

    (jQuery @car).on 'crossFinishLine', => @finish()
    @gameLoopController.start => @update()

  finish: ->
    @endTime = new Date().getTime()
    @set 'raceTime', @endTime - @startTime
    @car.reset()
    @_resetCarPosition()
    @startTime = new Date().getTime()

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

      # cares for correct orientation
      @car.jumpstart()
      @car.moveTo { x: nextPosition.x, y: nextPosition.y }

      if (@car.get 'lengthAtTrack') >= @track.getTotalLength()
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
    @_resetCarPosition()

  _resetCarPosition: ->
    position = @track.getPointAtLength 0
    @car.moveTo { x: position.x, y: position.y }

  _resetTime: ->
    @set 'raceTime', 0
    @startTime = new Date().getTime()