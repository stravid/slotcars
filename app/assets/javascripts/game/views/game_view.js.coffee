
#= require helpers/namespace
#= require game/templates/game_template

namespace 'game.views'

game.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'game_templates_game_template'

  onRestartClick: ->
    @gameController.restartGame()

  raceTimeInSeconds: (Ember.computed ->
    @convertMillisecondsToSeconds (@gameController.get 'raceTime')
  ).property 'gameController.raceTime'

  convertMillisecondsToSeconds: (value) ->
    value / 1000
