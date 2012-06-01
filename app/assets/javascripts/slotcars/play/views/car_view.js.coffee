Play.CarView = Ember.View.extend

  templateName: 'slotcars_play_templates_car_view_template'
  tagName: ''

  car: null

  didInsertElement: -> @update()

  update: (->
    rotation = @car.rotation

    (jQuery '#car').css '-webkit-transform', "rotateZ(#{rotation}deg)"
  ).observes 'car.rotation'
