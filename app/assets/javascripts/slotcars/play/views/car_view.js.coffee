Play.CarView = Ember.View.extend

  templateName: 'slotcars_play_templates_car_view_template'
  elementId: 'car'

  car: null

  didInsertElement: -> @update()

  update: (->
    rotation = @car.rotation

    @$().css '-webkit-transform', "rotateZ(#{rotation}deg)"
    @$().css '-moz-transform', "rotateZ(#{rotation}deg)"
    @$().css '-o-transform', "rotate(#{rotation}deg)"
  ).observes 'car.rotation'
