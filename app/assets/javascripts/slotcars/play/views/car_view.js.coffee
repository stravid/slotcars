Play.CarView = Ember.View.extend

  templateName: 'slotcars_play_templates_car_view_template'
  tagName: ''

  car: null
  offset: null

  width: 27
  height: 39
  puffInterval: 2
  puffStep: 0

  didInsertElement: ->
    (jQuery '#car').css 'top', 0
    (jQuery '#car').css 'left', 0
    (jQuery '#car').css '-webkit-transform', "translate3d(0,-10000px,0)"
    (jQuery '#car').css '-moz-transform', "translate3d(0,-10000px,0)"

  onPositionChange: (-> @update()).observes 'car.position'

  update: ->
    position = @car.position
    rotation = @car.rotation
    offset = @car.steeringOffset

    drawPosition =
      x: position.x
      y: position.y

    (jQuery '#car').css '-webkit-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    (jQuery '#car').css '-moz-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"

    (jQuery '#car-offset').css 'left', offset
