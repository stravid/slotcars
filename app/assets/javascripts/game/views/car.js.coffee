
#= require helpers/namespace
#= require helpers/graphic/exhaust

namespace 'game.views'

@game.views.CarView = Ember.Object.extend

  paper: null
  width: 27
  height: 39
  car: null
  exhaust: null
  puffInterval: 2
  puffStep: 0
  
  init: ->
    @exhaust = helpers.graphic.Exhaust.create(@paper)
    @_buildCar()
    @mediator.addObserver 'position', => @update()

  update: ->
    position = @mediator.get 'position'
    position.x -= @width / 2
    position.y -= @height / 4 * 1
    
    @car.attr position
    
    #@puffStep = ++@puffStep % @puffInterval
    #@exhaust.puff(position.x + @width - 6, position.y + @height) unless @puffStep > 0
    
    #@exhaust.update()
  
  _buildCar: ->
    position = @mediator.get 'position'
    
    @car = @paper.rect position.x, position.y, @width, @height
    @car.attr 'fill', 'url(assets/car/car-red.png)'
    @car.attr 'stroke', 'none'
