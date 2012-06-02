describe 'play screen view', ->

  it 'should extend Ember.View', ->
    (expect Play.PlayScreenView).toExtend Ember.View

  it 'should use a dynamic view in its template that can be set', ->
    playScreenView = Play.PlayScreenView.create()
    container = jQuery '<div>'

    Ember.run => playScreenView.appendTo container

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    Ember.run => playScreenView.set 'contentView', testContentView

    (expect playScreenView.$()).toContain '#' + testContentViewId
