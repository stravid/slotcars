
#= require helpers/namespace
#= require game/mediators/game_mediator

namespace 'game.views'

@game.views.GameView = Ember.Object.extend
  body: null
  container: jQuery '<div>'
  timeContainer: jQuery '<div id="race-time">'
  
  init: ->
    @body or= jQuery document.body
    
    raceTime = @mediator.get 'raceTime'
    @timeContainer.text raceTime
    
    @mediator.addObserver 'raceTime', => @onRaceTimeChange()
    
    @container.append @timeContainer
    @body.prepend @container
    
  onRaceTimeChange: ->
    @timeContainer.text @formatTime @mediator.get 'raceTime'
    
  formatTime: (value) ->
    value / 1000 + ' seconds'
    