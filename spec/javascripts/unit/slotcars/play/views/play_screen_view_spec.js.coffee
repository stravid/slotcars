
#= require slotcars/play/views/play_screen_view

describe 'play screen view', ->

  PlayScreenView = slotcars.play.views.PlayScreenView

  it 'should extend Ember.View', ->
    (expect PlayScreenView).toExtend Ember.View