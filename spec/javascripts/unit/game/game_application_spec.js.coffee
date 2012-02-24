
#= require game/game_application

describe 'game.GameApplication (unit)', ->

  GameApplication = game.GameApplication

  it 'should extend Ember.View', ->
    (expect Ember.View.detect GameApplication).toBe true