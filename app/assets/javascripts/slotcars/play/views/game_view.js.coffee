
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

  onCountdownVisibleChange: ( ->
    if @gameController.get 'isCountdownVisible'
      (@$ '#countdown').show() 
    else 
      (@$ '#countdown').hide()
  ).observes 'gameController.isCountdownVisible'

  convertMillisecondsToSeconds: (value) ->
    value / 1000
