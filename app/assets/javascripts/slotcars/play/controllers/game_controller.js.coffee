
#= require slotcars/shared/controllers/base_game_controller
#= require slotcars/play/controllers/game_loop_controller
#= require slotcars/play/views/car_view

#= require helpers/event_normalize

CarView = slotcars.play.views.CarView
GameLoopController = slotcars.play.controllers.GameLoopController
BaseGameController = Slotcars.shared.controllers.BaseGameController

(namespace 'slotcars.play.controllers').GameController = BaseGameController.extend
  
  isCountdownVisible: false
  isRaceFinished: false
  currentCountdownValue: null

  startTime: null
  endTime: null
  raceTime: null

  timeouts: []
  lapTimes: []

  start: ->
    @_super()
    @restartGame()

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
    @_super()
    @_setCurrentTime()

  restartGame: ->
    @set 'carControlsEnabled', false
    @set 'isRaceFinished', false
    @set 'raceTime', 0
    @set 'lapTimes', []

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

  destroy: ->
    # clear all timeouts
    @_clearTimeouts()

    # force unbinding of car controls
    @set 'carControlsEnabled', false

    @gameLoopController.destroy()
