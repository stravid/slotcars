
#= require slotcars/play/templates/game_view_template

namespace('slotcars.play.views').GameView = Ember.View.extend

  elementId: 'game-view'
  templateName: 'slotcars_play_templates_game_view_template'
  gameController: null

  onRestartClick: ->
    @gameController.restartGame()

  raceTimeInSeconds: (Ember.computed ->
    @convertMillisecondsToSeconds (@gameController.get 'raceTime')
  ).property 'gameController.raceTime'

  onCountdownVisibleChange: ( ->
    if @gameController.get 'isCountdownVisible'
      (@$ '#countdown').removeClass 'squashed'
    else 
      (@$ '#countdown').addClass 'squashed'
  ).observes 'gameController.isCountdownVisible'

  convertMillisecondsToSeconds: (value) ->
    value / 1000
