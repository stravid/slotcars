
#= require helpers/namespace
#= require game/mediators/game_mediator

namespace 'game.views'

@game.views.GameView = Ember.View.extend
  
  templateName: 'game_templates_game_template'
  #container: jQuery '<div>'
  #formattedRaceTime: jQuery '<div id="race-time">'
  restartButton: jQuery '<button id="restart-button">Start</button>'
  
  init: ->
    @body or= jQuery document.body
    
    #@formattedRaceTime.text @mediator.get 'raceTime'
    #@restartButton.on 'click', => @onStartClick()
    
    @mediator.addObserver 'raceTime', => @onRaceTimeChange()
    
    @buildUI()
    
  buildUI: ->
#    @container.append @formattedRaceTime
#    @container.append @restartButton
    
#    @body.prepend @container
#  console.log @get 'formattedRaceTime'
    
  onRaceTimeChange: ->
    @raceTimeInSeconds
    
#  onStartClick: ->
#    (jQuery this).trigger 'startGame'
  
  raceTimeInSeconds: ( ->
    @formatTime @mediator.get 'raceTime'
  ).property()

  formatTime: (value) ->
    value / 1000
    