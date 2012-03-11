
#= require helpers/namespace
#= require slotcars/play/templates/game_template

namespace 'slotcars.play.views'

slotcars.play.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'slotcars_play_templates_game_template'
  gameController: null

  onRestartClick: ->
    @gameController.restartGame()

  raceTimeInSeconds: (Ember.computed ->
    @convertMillisecondsToSeconds (@gameController.get 'raceTime')
  ).property 'gameController.raceTime'

  convertMillisecondsToSeconds: (value) ->
    value / 1000
