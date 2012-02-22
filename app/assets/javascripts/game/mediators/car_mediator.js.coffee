
#= require helpers/namespace

namespace 'game.mediators'

@game.mediators.CarMediator = Ember.Object.extend

  position: Ember.Object.create
    x: 0
    y: 0