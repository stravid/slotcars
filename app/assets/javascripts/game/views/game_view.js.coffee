
#= require helpers/namespace
#= require game/mediators/game_mediator

namespace 'game.views'

@game.views.GameView = Ember.View.extend

  templateName: 'game_templates_game_template'
  
  didInsertElement: ->
    console.log "test"
  
  init: ->
    @mediator.addObserver 'raceTime', => @onRaceTimeChange()

  onRaceTimeChange: ->
    @raceTimeInSeconds

  onRestartClick: ->
    (jQuery this).trigger 'restartGame'

  raceTimeInSeconds: ( ->
    @formatTime @mediator.get 'raceTime'
  ).property()

  formatTime: (value) ->
    value / 1000
