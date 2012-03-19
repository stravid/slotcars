
#= require slotcars/play/controllers/game_loop_controller
#= require slotcars/shared/models/car
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
  
  isCountdownVisible: false
  isRaceFinished: false
  currentCountdownValue: null

  startTime: null
  endTime: null
  raceTime: null

  timeouts: []
  lapTimes: []

  init: ->
    (@get 'car').set 'track', (@get 'track')
    @gameLoopController = GameLoopController.create()

    unless @track?
      throw new Error 'track has to be provided'
    unless @car?
      throw new Error 'car has to be provided'

  start: ->
    @restartGame()
    @gameLoopController.start => @update()

  finish: ->
    @_setCurrentTime()
    @onLapChange()

    @set 'isRaceFinished', true
    @set 'carControlsEnabled', false
    @isTouchMouseDown = false

  onCarCrossedFinishLine: (->
    car = @get 'car'
    if car.get 'crossedFinishLine' then @finish()
  ).observes 'car.crossedFinishLine'
  
  onLapChange: (->
    lapTimes = @get 'lapTimes'
    sum = lapTimes.reduce (previous, current) -> 
      previous + current
    , 0
    unless (@get 'raceTime') == sum
      lapTimes.push (@get 'raceTime') - sum
    @set 'lapTimes', lapTimes

  ).observes 'car.currentLap'

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

    @_setCurrentTime()

  onTouchMouseDown: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = true

  onTouchMouseUp: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = false

  restartGame: ->
    @set 'carControlsEnabled', false
    @set 'isRaceFinished', false
    @set 'raceTime', 0
    @set 'lapTimes', []

    position = @track.getPointAtLength 0
    @car.moveTo { x: position.x, y: position.y }

    @car.jumpstart()
    @car.reset()

    @set 'currentCountdownValue', 3
    @set 'isCountdownVisible', true

    @_clearTimeouts()
    @timeouts[0] = setTimeout (=> @set 'currentCountdownValue', 2 ), 1000
    @timeouts[1] = setTimeout (=> @set 'currentCountdownValue', 1 ), 2000

    @timeouts[2] = setTimeout (=>
      @set 'carControlsEnabled', true
      @startTime = new Date().getTime()
      @set 'currentCountdownValue', 'Go!'
    ), 3000

    @timeouts[3] = setTimeout (=> @set 'isCountdownVisible', false ), 3500

  _clearTimeouts: ->
    for timeout in @timeouts
      clearTimeout timeout

  _setCurrentTime: ->
    @endTime = new Date().getTime()
    if @get 'carControlsEnabled'
      @set 'raceTime', @endTime - @startTime
