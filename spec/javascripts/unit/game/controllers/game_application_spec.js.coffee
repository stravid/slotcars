
#= require game/game_application
#= require game/views/track

describe 'game.GameApplication (unit)', ->

  GameApplication = game.GameApplication

  it 'should extend Ember.Application', ->
    (expect Ember.Application.detect GameApplication).toBe true