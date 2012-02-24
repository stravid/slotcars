
#= require builder/mediators/track_mediator

describe 'builder.mediators.TrackMediator', ->

  TrackMediator = builder.mediators.TrackMediator

  it 'should extend Ember.Object', ->
    (expect Ember.Object.detect TrackMediator).toBe true