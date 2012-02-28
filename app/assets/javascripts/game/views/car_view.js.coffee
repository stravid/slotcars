
#= require helpers/namespace
#= require helpers/graphic/exhaust
#= require game/mediators/car_mediator
#= require game/templates/car_template

namespace 'game.views'

game.views.CarView = Ember.View.extend

  templateName: 'game_templates_car_template'
  tagName: ''

  paper: null
  width: 27
  height: 39
  car: null
  exhaust: null
  puffInterval: 2
  puffStep: 0
  carMediator: game.mediators.carMediator
  offset: null

  didInsertElement: ->
    #@exhaust = helpers.graphic.Exhaust.create(@paper)

    (jQuery @$()).css 'top', @offset.top
    (jQuery @$()).css 'left', @offset.left

  onPositionChange: (-> @update()).observes 'carMediator.position'

  update: ->
    position = @carMediator.get 'position'
    position.x -= @width / 2
    position.y -= @height / 4 * 1

    (jQuery '#car').css '-webkit-transform', "translate3d(#{position.x}px,#{position.y}px,0)"

    #@puffStep = ++@puffStep % @puffInterval
    #@exhaust.puff(position.x + @width - 6, position.y + @height) unless @puffStep > 0

    #@exhaust.update()
