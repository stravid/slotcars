
#= require game/controllers/game_application
#= require game/views/track

describe 'game.controllers.GameApplication', ->

  GameApplication = game.controllers.GameApplication

  it 'should extend Ember.Application', ->
    (expect Ember.Application.detect GameApplication).toBe true