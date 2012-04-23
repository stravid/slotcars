Shared.BaseGameController = Ember.Object.extend

  track: null
  car: null
  gameLoopController: null
  isTouchMouseDown: false
  carControlsEnabled: false

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

  start: ->
    @gameLoopController.start => @update()

  update: ->
    @car.update @isTouchMouseDown

  destroy: ->
    @_super()
    @gameLoopController.destroy()
