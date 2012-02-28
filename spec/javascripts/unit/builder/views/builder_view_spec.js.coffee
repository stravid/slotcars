#= require builder/views/builder_view


describe 'builder.views.BuilderView (unit)', ->
  
  BuilderView = builder.views.BuilderView
  
  it 'should extend Ember.View', ->
    (expect Ember.Object.detect BuilderView).toBe true
