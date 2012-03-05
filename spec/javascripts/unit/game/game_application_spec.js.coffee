
#= require game/game_application

describe 'game.GameApplication (unit)', ->

  GameApplication = game.GameApplication

  it 'should extend Ember.View', ->
    (expect GameApplication).toExtend Ember.View