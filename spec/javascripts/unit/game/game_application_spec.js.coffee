
#= require game/game_application
#= require game/views/track

describe 'game.GameApplication (unit)', ->

  GameApplication = game.GameApplication

  it 'should extend Ember.View', ->
    (expect Ember.View.detect GameApplication).toBe true