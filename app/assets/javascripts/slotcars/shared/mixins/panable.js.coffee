Shared.Panable = Ember.Mixin.create

  car: Ember.required()
  classNames: ['panable']
  padding:
    left: SCREEN_WIDTH
    top: SCREEN_HEIGHT

  onCarPositionChange: ( ->
    position = @car.position

    # calculation steps: 1. scale position, 2. shift to center (subtract half screen size), 3. add padding
    drawPosition =
      x: position.x * @scaleFactor - SCREEN_WIDTH/2  + @padding.left
      y: position.y * @scaleFactor - SCREEN_HEIGHT/2 + @padding.top

    if @$()?
      @$().css '-webkit-backface-visibility', 'hidden'
      @$().css '-webkit-transform', "translate3d(#{-drawPosition.x}px,#{-drawPosition.y}px,0)"
  ).observes 'car.position'
