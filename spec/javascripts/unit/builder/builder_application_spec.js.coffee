
#= require builder/builder_application

describe 'builder.BuilderApplication (unit)', ->

  BuilderApplication = builder.BuilderApplication

  it 'should extend Ember.View', ->
    (expect BuilderApplication).toExtend Ember.View