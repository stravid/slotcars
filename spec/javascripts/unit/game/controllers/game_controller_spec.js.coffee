
#= require game/controllers/game_controller
#= require game/views/track

describe 'game.controllers.GameController', ->

  GameController = game.controllers.GameController

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect GameController).toBe true