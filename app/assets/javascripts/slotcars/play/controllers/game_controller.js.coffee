
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
  carControlsEnabled: false
  
  showCountdown: false
  currentCountdownValue: null

  startTime: null
  endTime: null
  raceTime: null

  init: ->
    @gameLoopController = GameLoopController.create()

    unless @track?
      throw new Error 'track has to be provided'
    unless @car?
      throw new Error 'car has to be provided'

  start: ->
    @restartGame()
    @gameLoopController.start => @update()

  finish: ->
    (jQuery @car).off 'crossFinishLine'
    @endTime = new Date().getTime()
    @set 'raceTime', @endTime - @startTime

    @set 'carControlsEnabled', false
    @isTouchMouseDown = false

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
    @set 'carControlsEnabled', false

    position = @track.getPointAtLength 0
    @car.moveTo { x: position.x, y: position.y }

    @car.jumpstart()
    @car.reset()

    (jQuery @car).on 'crossFinishLine', => @finish()

    @set 'raceTime', 0

    @set 'currentCountdownValue', 3
    @set 'showCountdown', true

    setTimeout (=> @set 'currentCountdownValue', 2 ), 1000
    setTimeout (=> @set 'currentCountdownValue', 1 ), 2000

    setTimeout (=>
      @set 'carControlsEnabled', true
      @startTime = new Date().getTime()
      @set 'currentCountdownValue', 'Go!'
    ), 3000

    setTimeout (=> @set 'showCountdown', false ), 4000
