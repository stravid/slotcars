Shared.Controllable = Ember.Mixin.create

  gameController: Ember.required()
  
  didInsertElement: ->
    @_super()
    @onCarControlsChange()

  onCarControlsChange: (->
    @$().off 'touchMouseDown'
    (jQuery document).off 'touchMouseUp'

    if @gameController.get 'carControlsEnabled'
      @$().on 'touchMouseDown', (event) => @gameController.onTouchMouseDown event
      (jQuery document).on 'touchMouseUp', (event) => @gameController.onTouchMouseUp event

  ).observes 'gameController.carControlsEnabled'
