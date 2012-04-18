describe 'slotcars.tracks.controllers.TracksController', ->

  TracksController = slotcars.tracks.controllers.TracksController

  it 'should extend Ember.Object', ->
    (expect TracksController).toExtend Ember.Object