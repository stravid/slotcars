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
    @$().on 'touchMouseDown.controllable', (event) => @gameController.onTouchMouseDown event
    (jQuery document).on 'touchMouseUp.controllable', (event) => @gameController.onTouchMouseUp event

  setupKeyListeners: ->
    (jQuery document).on 'keydown.controllable', (event) => @gameController.onKeyDown event
    (jQuery document).on 'keyup.controllable', (event) => @gameController.onKeyUp event

  removeTouchListeners: ->
    @$().off 'touchMouseDown.controllable'
    (jQuery document).off 'touchMouseUp.controllable'

  removeKeyListeners: ->
    (jQuery document).off 'keydown.controllable'
    (jQuery document).off 'keyup.controllable'
