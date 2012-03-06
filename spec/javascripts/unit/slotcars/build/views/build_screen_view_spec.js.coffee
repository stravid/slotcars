
#= require slotcars/build/views/build_screen_view

describe 'build screen view', ->

  BuildScreenView = slotcars.build.views.BuildScreenView

  it 'should extend Ember.View', ->
    (expect Ember.View.detect BuildScreenView).toBe true

  it 'should use a dynamic view in its template that can be set', ->
    buildScreenView = BuildScreenView.create()
    container = jQuery '<div>'

    Ember.run => buildScreenView.appendTo container

    testContentViewId = 'test-content-view'
    testContentView = Ember.View.create elementId: testContentViewId

    Ember.run => buildScreenView.set 'contentView', testContentView

    (expect buildScreenView.$()).toContain '#' + testContentViewId