describe 'track screen view', ->

  it 'should extend Ember.View', ->
    (expect Tracks.TracksScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    tracksScreenView = Tracks.TracksScreenView.create()
    container = jQuery '<div>'

    tracksScreenView.appendTo container

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    tracksScreenView.set 'contentView', testContentView

    Ember.run.end()

    (expect tracksScreenView.$()).toContain '#' + testContentViewId
