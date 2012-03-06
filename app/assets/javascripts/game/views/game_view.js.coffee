
#= require helpers/namespace
#= require game/templates/game_template
#= require game/mediators/game_mediator

namespace 'game.views'

game.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'game_templates_game_template'

  raceTimeBinding: 'gameController.raceTime'

  onRestartClick: ->
    @gameController.restartGame()

  raceTimeInSeconds: (Ember.computed ->
    @formatTime (@gameController.get 'raceTime')
  ).property 'gameController.raceTime'

  formatTime: (value) ->
    value / 1000
