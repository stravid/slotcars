
#= require game/views/track

describe 'game.views.TrackView', ->
  
  TrackView = game.views.TrackView
  
  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect TrackView).toBe true