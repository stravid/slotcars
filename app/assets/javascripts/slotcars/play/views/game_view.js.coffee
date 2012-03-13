
#= require helpers/namespace
#= require helpers/graphic/clock
#= require slotcars/play/templates/game_template

namespace 'slotcars.play.views'

slotcars.play.views.GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'slotcars_play_templates_game_template'
  gameController: null
  
  clock: new helpers.graphic.Clock()

  didInsertElement: ->
    @clock.findNodes()

  onRestartClick: ->
    @gameController.restartGame()

  onRaceTimeChange: ( ->
    @clock.updateTime @gameController.get 'raceTime'
    
  ).observes 'gameController.raceTime'
