
#= require helpers/namespace
#= require helpers/graphic/exhaust
#= require slotcars/play/templates/car_template

namespace 'slotcars.play.views'

slotcars.play.views.CarView = Ember.View.extend

  templateName: 'slotcars_play_templates_car_template'
  tagName: ''

  car: null
  offset: null

  width: 27
  height: 39
  exhaust: null
  puffInterval: 2
  puffStep: 0

  didInsertElement: ->
    #@exhaust = helpers.graphic.Exhaust.create(@paper)

    if @offset?
      (jQuery @$()).css 'top', @offset.top
      (jQuery @$()).css 'left', @offset.left

  onPositionChange: (-> @update()).observes 'car.position'

  update: ->
    position = @car.position
    rotation = @car.rotation
    drawPosition =
      x: position.x - @width / 2
      y: position.y - @height / 4

    (jQuery @$()).css '-webkit-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    (jQuery @$()).css '-moz-transform', "translate3d(#{drawPosition.x}px,#{drawPosition.y}px,0)rotateZ(#{rotation}deg)"
    
    #@puffStep = ++@puffStep % @puffInterval
    #@exhaust.puff(position.x + @width - 6, position.y + @height) unless @puffStep > 0

    #@exhaust.update()
