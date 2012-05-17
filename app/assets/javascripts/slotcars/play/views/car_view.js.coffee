Play.CarView = Ember.View.extend

  templateName: 'slotcars_play_templates_car_view_template'
  tagName: ''

  car: null
  offset: null

  puffInterval: 2
  puffStep: 0

  didInsertElement: ->
    (jQuery '#car').css 'top', 384
    (jQuery '#car').css 'left', 512

  onPositionChange: (-> @update()).observes 'car.position'

  update: ->
    rotation = @car.rotation
    
    (jQuery '#car').css '-webkit-transform', "rotateZ(#{rotation}deg)"
