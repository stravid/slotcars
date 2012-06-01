Play.CarView = Ember.View.extend

  templateName: 'slotcars_play_templates_car_view_template'
  tagName: ''

  car: null

  didInsertElement: ->
    (jQuery '#car').css 'top', SCREEN_HEIGHT / 2
    (jQuery '#car').css 'left', SCREEN_WIDTH / 2
    @update()

  update: (->
    rotation = @car.rotation
    
    (jQuery '#car').css '-webkit-transform', "rotateZ(#{rotation}deg)"
  ).observes 'car.rotation'