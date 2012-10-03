Shared.Controllable = Ember.Mixin.create

  gameController: Ember.required()

  # zoom into the track
  scaleFactor: 2

  didInsertElement: ->
    @_super()
    @setupTouchListeners()

  setupTouchListeners: ->
    @$().on 'touchMouseDown', (event) => @gameController.onTouchMouseDown event
    (jQuery document).on 'touchMouseUp', (event) => @gameController.onTouchMouseUp event

  destroy: ->
    @_removeTouchListeners()
    @_super()

  _removeTouchListeners: ->
    @$().off 'touchMouseDown'
    (jQuery document).off 'touchMouseUp'
