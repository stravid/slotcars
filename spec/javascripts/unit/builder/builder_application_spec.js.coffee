
#= require builder/builder_application

describe 'builder.BuilderApplication (unit)', ->

  BuilderApplication = builder.BuilderApplication

  it 'should extend Ember.View', ->
    (expect Ember.View.detect BuilderApplication).toBe true