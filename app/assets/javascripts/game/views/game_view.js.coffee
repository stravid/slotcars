
#= require helpers/namespace
#= require game/mediators/game_mediator

namespace 'game.views'

@game.views.GameView = Ember.Object.extend
  container: ($ '<div>')
  timeContainer: ($ '<div id="race-time">')
  
  init: ->
    raceTime = @mediator.get 'raceTime'
    @timeContainer.text raceTime
    
    @mediator.addObserver 'raceTime', => @onRaceTimeChange()
    
    @container.append(@timeContainer)
    
  onRaceTimeChange: ->
    @timeContainer.text @mediator.get 'raceTime'