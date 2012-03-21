
#= require slotcars/tracks/views/tracks_screen_view

describe 'track screen view', ->

  TracksScreenView = slotcars.tracks.views.TracksScreenView

  it 'should extend Ember.View', ->
    (expect TracksScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    tracksScreenView = TracksScreenView.create()
    container = jQuery '<div>'

    tracksScreenView.appendTo container

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    tracksScreenView.set 'contentView', testContentView

    Ember.run.end()

    (expect tracksScreenView.$()).toContain '#' + testContentViewId
