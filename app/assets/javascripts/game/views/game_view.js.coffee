
#= require helpers/namespace
#= require game/mediators/game_mediator

namespace 'game.views'

@game.views.GameView = Ember.Object.extend
  body: null
  container: jQuery '<div>'
  timeContainer: jQuery '<div id="race-time">'
  restartButton: jQuery '<button id="restart-button">Start</button>'
  
  init: ->
    @body or= jQuery document.body
    
    @timeContainer.text @mediator.get 'raceTime'
    @restartButton.on 'click', => @onStartClick()
    
    @mediator.addObserver 'raceTime', => @onRaceTimeChange()
    
    @buildUI()
    
  buildUI: ->
    @container.append @timeContainer
    @container.append @restartButton
    
    @body.prepend @container
    
  onRaceTimeChange: ->
    @timeContainer.text @formatTime @mediator.get 'raceTime'
    
  onStartClick: ->
    (jQuery this).trigger 'startGame'
    
  formatTime: (value) ->
    value / 1000 + ' seconds'
    