
#= require helpers/namespace
#= require game/templates/game_template

namespace 'game.views'

game.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'game_templates_game_template'

  onRestartClick: ->
    (jQuery this).trigger 'restartGame'

  raceTimeInSeconds: (Ember.computed ->
    @formatTime @mediator.get 'raceTime'
  ).property 'mediator.raceTime'

  formatTime: (value) ->
    value / 1000


