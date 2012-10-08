Shared.Panable = Ember.Mixin.create

  car: Ember.required()
  classNames: ['panable']

  didInsertElement: ->
    @$().css 'width', SCREEN_WIDTH * @scaleFactor
    @$().css 'height', SCREEN_HEIGHT * @scaleFactor

    @_super()

  onCarPositionChange: ( ->
    position = @car.position
    drawPosition =
      x: position.x * @scaleFactor
      y: position.y * @scaleFactor

    if @$()?
      @$().css '-webkit-backface-visibility', 'hidden'
      @$().css '-webkit-transform', "translate3d(#{-drawPosition.x}px,#{-drawPosition.y}px,0)"
  ).observes 'car.position'
