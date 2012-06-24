Shared.Panable = Ember.Mixin.create

  car: Ember.required()
  classNames: ['panable']

  onCarPositionChange: ( ->
    position = @car.position
    drawPosition =
      x: position.x * @scaleFactor + SCREEN_WIDTH / 2
      y: position.y * @scaleFactor + SCREEN_HEIGHT / 2

    @$().css '-webkit-transform', "translate3d(#{-drawPosition.x}px,#{-drawPosition.y}px,0)"
    @$().css '-moz-transform', "translate3d(#{-drawPosition.x}px,#{-drawPosition.y}px,0)"
    @$().css '-o-transform', "translate(#{-drawPosition.x}px,#{-drawPosition.y}px)"
  ).observes 'car.position'
