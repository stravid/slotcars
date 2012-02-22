
#= require game/views/game_view

describe 'game.views.GameView (unit)', ->

  GameView = game.views.GameView
  
  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect GameView).toBe true
