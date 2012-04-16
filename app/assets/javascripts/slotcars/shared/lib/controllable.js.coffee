
namespace('Slotcars.shared.lib').Controllable = Ember.Mixin.create

  gameController: Ember.required()
  
  didInsertElement: ->
    @_super()
    @onCarControlsChange()

  onCarControlsChange: (->
    @$().off 'touchMouseDown'
    @$().off 'touchMouseUp'

    if @gameController.get 'carControlsEnabled'
      @$().on 'touchMouseDown', (event) => @gameController.onTouchMouseDown event
      @$().on 'touchMouseUp', (event) => @gameController.onTouchMouseUp event

  ).observes 'gameController.carControlsEnabled'
