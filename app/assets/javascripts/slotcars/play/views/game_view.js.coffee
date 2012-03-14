
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

  countdown: (Ember.computed ->
    # currentCountdown = @gameController.get 'countdownInSeconds'
    # interval = setInterval (=>
    #   unless currentCountdown == 0
    #     currentCountdown = currentCountdown - 1
    #   else
    #     currentCountdown = 'GO'
    # ), 1000
    # console.log currentCountdown
    # currentCountdown
  ).property 'currentCountdown'

  convertMillisecondsToSeconds: (value) ->
    value / 1000
