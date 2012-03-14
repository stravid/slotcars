
#= require slotcars/play/views/play_screen_view

describe 'play screen view', ->

  PlayScreenView = slotcars.play.views.PlayScreenView

  it 'should extend Ember.View', ->
    (expect PlayScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    playScreenView = PlayScreenView.create()
    container = jQuery '<div>'

    playScreenView.appendTo container

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    playScreenView.set 'contentView', testContentView

    Ember.run.end()

    (expect playScreenView.$()).toContain '#' + testContentViewId
