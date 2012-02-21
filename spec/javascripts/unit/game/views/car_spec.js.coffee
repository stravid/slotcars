
#= require game/views/car

describe 'game.views.CarView (unit)', ->

  CarView = game.views.CarView

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect CarView).toBe true