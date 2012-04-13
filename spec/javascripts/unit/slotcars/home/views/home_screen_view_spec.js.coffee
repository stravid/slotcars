
#= require slotcars/home/views/home_screen_view
#= require slotcars/shared/components/widget

describe 'home screen view', ->

  HomeScreenView = slotcars.home.views.HomeScreenView

  it 'should extend Ember.View', ->
    (expect HomeScreenView).toExtend Ember.View

  it 'should provide widget location for right column', ->
    homeScreenView = HomeScreenView.create()

    testWidgetView = Ember.View.create()
    container = jQuery '<div>'

    homeScreenView.set 'rightColumn', testWidgetView
    homeScreenView.appendTo container

    Ember.run.end()

    (expect homeScreenView.$()).toContain testWidgetView.$()