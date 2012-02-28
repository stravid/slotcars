
#= require helpers/namespace
#= require game/templates/game_template
#= require game/mediators/game_mediator

namespace 'game.views'

game.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'game_templates_game_template'

  gameMediator: game.mediators.gameMediator

  onRestartClick: ->
    (jQuery this).trigger 'restartGame'

  raceTimeInSeconds: (Ember.computed ->
    @formatTime @gameMediator.get 'raceTime'
  ).property 'gameMediator.raceTime'

  formatTime: (value) ->
    value / 1000


