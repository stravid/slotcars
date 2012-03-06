
#= require slotcars/home/views/home_screen_view

describe 'home screen view', ->

  HomeScreenView = slotcars.home.views.HomeScreenView

  it 'should extend Ember.View', ->
    (expect HomeScreenView).toExtend Ember.View