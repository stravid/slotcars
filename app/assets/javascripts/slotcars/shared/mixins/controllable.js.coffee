Shared.Controllable = Ember.Mixin.create

  gameController: Ember.required()

  # zoom into the track
  scaleFactor: 2

  didInsertElement: ->
    @_super()
    @setupTouchListeners()
    @setupKeyListeners()

  willDestroyElement: ->
    @removeTouchListeners()
    @removeKeyListeners()
    @_super()

  setupTouchListeners: ->
    @$().on 'touchMouseDown', (event) => @gameController.onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @gameController.onTouchMouseUp event

  setupKeyListeners: ->
    (jQuery document).on 'keydown', (event) => @gameController.onKeyDown event
    (jQuery document).on 'keyup', (event) => @gameController.onKeyUp event

  removeTouchListeners: ->
    @$().off 'touchMouseDown'
    (jQuery document).off 'touchMouseUp'

  removeKeyListeners: ->
    (jQuery document).off 'keydown', @gameController.onKeyDown
    (jQuery document).off 'keyup', @gameController.onKeyUp
