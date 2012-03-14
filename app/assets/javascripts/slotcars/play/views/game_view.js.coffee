
#= require helpers/namespace
#= require slotcars/play/templates/game_view_template

namespace 'slotcars.play.views'

slotcars.play.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'slotcars_play_templates_game_view_template'
  gameController: null

  onRestartClick: ->
    @gameController.restartGame()
