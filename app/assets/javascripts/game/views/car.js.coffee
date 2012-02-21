#= require helpers/namespace

namespace 'game.views'

@game.views.CarView = Ember.Object.extend
  init: ->
    @mediator.addObserver 'position', => @update()
    @car = @paper.rect()

  update: ->
    @car.attr @mediator.get 'position'