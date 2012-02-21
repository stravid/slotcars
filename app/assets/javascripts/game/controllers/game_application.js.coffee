
#= require helpers/namespace
#= require game/controllers/game_controller

namespace 'game.controllers'

@game.controllers.GameApplication = Ember.Application.extend

  ready: ->
    game.controllers.GameController.create
      rootElement: $(@rootElement)[0]

