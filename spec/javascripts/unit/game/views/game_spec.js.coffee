
#= require game/views/game_view

describe 'game.views.GameView (unit)', ->

  GameView = game.views.GameView
  
  it 'should extend Ember.View', ->
    (expect Ember.View.detect GameView).toBe true
