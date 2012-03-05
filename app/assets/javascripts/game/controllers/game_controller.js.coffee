
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
    @car = Car.create
      acceleration: 0.1
      deceleration: 0.2
      offRoadDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @carView = CarView.create
      car: @car

    @carView.append()

    (jQuery document).on 'touchMouseDown', (event) => @onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @onTouchMouseUp event

    (jQuery @car).on 'crossFinishLine', => @finish()
    (jQuery @car).on 'crossFinishLine', => @car.reset()

    (jQuery @gameView).on 'restartGame', => @restartGame()    

    unless @track?
      throw new Error 'track has to be provided'

  start: ->
    @_resetTime()
    position = @track.getPointAtLength @car.get 'lengthAtTrack'
    @car.moveTo { x: position.x, y: position.y }

    @gameLoopController.start => @update()

  finish: ->
    @endTime = new Date().getTime()
    @raceTime = @endTime - @startTime

  update: ->
    if @isTouchMouseDown
      @car.accelerate()
    else
      unless @car.isCrashing then @car.decelerate() else @car.crashcelerate()

    newLengthAtTrack = (@car.get 'lengthAtTrack') + @car.get 'speed'
    position = @track.getPointAtLength newLengthAtTrack
    @car.moveTo { x: position.x, y: position.y }

    if @car.get 'lengthAtTrack' > @track.totalLength
      (jQuery @car).trigger 'crossFinishLine'

  onTouchMouseDown: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = true

  onTouchMouseUp: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = false

  restartGame: ->
    @car.reset()

    position = @track.getPointAtLength @car.get 'lengthAtTrack'
    @car.moveTo { x: position.x, y: position.y }

    @_resetTime()

  _resetTime: ->
    @raceTime = 0
    @startTime = new Date().getTime()
