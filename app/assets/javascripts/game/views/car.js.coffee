#= require helpers/namespace

namespace 'game.views'

@game.views.CarView = Ember.Object.extend

  width: 20
  height: 10
  
  init: ->
    position = @mediator.get 'position'
    @car = @paper.rect(position.x, position.y, @width, @height)
    @mediator.addObserver 'position', => @update()

  update: ->
    @car.attr @mediator.get 'position'