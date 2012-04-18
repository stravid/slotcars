describe 'home screen view', ->

  HomeScreenView = slotcars.home.views.HomeScreenView

  it 'should extend Ember.View', ->
    (expect HomeScreenView).toExtend Ember.View