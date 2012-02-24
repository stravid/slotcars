#= require helpers/namespace

namespace 'game.views'

@game.views.CarView = Ember.Object.extend

  width: 27
  height: 39
  car: null
  
  init: ->
    @_buildCar()
    @mediator.addObserver 'position', => @update()

  update: ->
    position = @mediator.get 'position'
    position.x -= @width / 2
    position.y -= @height / 4 * 1
    
    @car.attr position
  
  _buildCar: ->
    position = @mediator.get 'position'
    
    @car = @paper.rect position.x, position.y, @width, @height
    @car.attr 'fill', 'url(assets/car/car-red.png)'
    @car.attr 'stroke', 'none'
