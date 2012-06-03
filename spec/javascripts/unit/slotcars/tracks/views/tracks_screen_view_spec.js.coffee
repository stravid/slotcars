describe 'track screen view', ->

  it 'should extend Ember.View', ->
    (expect Tracks.TracksScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    tracksScreenView = Tracks.TracksScreenView.create()

    Ember.run => tracksScreenView.appendTo jQuery '<div>'

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    Ember.run => tracksScreenView.set 'contentView', testContentView

    (expect tracksScreenView.$()).toContain '#' + testContentViewId
