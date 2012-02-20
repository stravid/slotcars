
#= require game/mediators/track

describe 'game.mediators.TrackMediator', ->
  
  TrackMediator = game.mediators.TrackMediator
  
  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect TrackMediator).toBe true