
#= require slotcars/play/controllers/play_controller

describe 'play controller', ->

  PlayController = slotcars.play.controllers.PlayController

  it 'should extend Ember.Object', ->
    (expect PlayController).toExtend Ember.Object