
#= require game/views/track_view

describe 'game.views.TrackView', ->
  
  TrackView = game.views.TrackView
  
  it 'should extend Ember.Object', ->
    (expect TrackView).toExtend Ember.Object