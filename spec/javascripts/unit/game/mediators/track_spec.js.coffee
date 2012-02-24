
#= require game/mediators/track_mediator

describe 'game.mediators.TrackMediator', ->
  
  TrackMediator = game.mediators.TrackMediator
  
  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect TrackMediator).toBe true