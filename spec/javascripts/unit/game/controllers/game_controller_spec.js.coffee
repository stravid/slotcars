
#= require game/controllers/game_application
#= require game/controllers/game_controller
#= require game/views/track

describe 'game.controllers.GameController', ->

  GameController = game.controllers.GameController

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect GameController).toBe true
    
  describe '#start', ->

    it 'should start timer on call start', ->
      gameController = GameController.create
        rootElement: $(document.body)[0]
      
      (expect gameController).toBeDefined()
