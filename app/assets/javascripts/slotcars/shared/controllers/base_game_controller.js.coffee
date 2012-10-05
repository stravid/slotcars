Shared.BaseGameController = Ember.Object.extend

  track: null
  car: null
  gameLoopController: null
  isTouchMouseDown: false

  isRaceRunning: false

  init: ->
    @gameLoopController = Play.GameLoopController.create()

    unless @track?
      throw new Error 'track has to be provided'
    unless @car?
      throw new Error 'car has to be provided'

  onTouchMouseDown: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = true

  onTouchMouseUp: (event) ->
    event.originalEvent.preventDefault()
    @isTouchMouseDown = false

  onKeyDown: (event) ->
    if event.keyCode is 32
      @isTouchMouseDown = true

  onKeyUp: (event) ->
    if event.keyCode is 32
      @isTouchMouseDown = false

  start: -> @gameLoopController.start => @update()

  update: ->
    if @isRaceRunning
      @car.drive @isTouchMouseDown
    else
      @car.drive false # disable control when race is not running

  destroy: ->
    @_super()
    @gameLoopController.destroy()
