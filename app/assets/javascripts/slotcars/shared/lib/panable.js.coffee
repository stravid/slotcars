Shared.Panable = Ember.Mixin.create

  car: Ember.required()
  classNames: ['panable']
  
  onCarPositionChange: ( ->
    position = @car.position
    drawPosition =
      x: position.x * @scaleFactor - 27 / 2 + 512
      y: position.y * @scaleFactor - 39 / 4 + 384

    @$().css '-webkit-transform', "translate3d(#{-drawPosition.x}px,#{-drawPosition.y}px,0)"
  ).observes 'car.position'