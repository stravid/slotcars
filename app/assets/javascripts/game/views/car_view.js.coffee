
#= require helpers/namespace
#= require helpers/graphic/exhaust
#= require game/mediators/car_mediator

namespace 'game.views'

game.views.CarView = Ember.Object.extend

  paper: null
  width: 27
  height: 39
  car: null
  exhaust: null
  puffInterval: 2
  puffStep: 0
  carMediator: game.mediators.carMediator
  
  init: ->
    @exhaust = helpers.graphic.Exhaust.create(@paper)
    @_buildCar()

  update: (->
    position = @carMediator.get 'position'
    position.x -= @width / 2
    position.y -= @height / 4 * 1
    
    @car.attr position
    @car.toFront()
    
    #@puffStep = ++@puffStep % @puffInterval
    #@exhaust.puff(position.x + @width - 6, position.y + @height) unless @puffStep > 0
    
    #@exhaust.update()
  ).observes 'carMediator.position'
  
  _buildCar: ->
    position = @carMediator.get 'position'
    
    @car = @paper.rect position.x, position.y, @width, @height
    @car.attr 'fill', 'url(/assets/car/car-red.png)'
    @car.attr 'stroke', 'none'
