#= require builder/views/builder_view


describe 'builder.views.BuilderView (unit)', ->
  
  BuilderView = builder.views.BuilderView
  
  it 'should extend Ember.View', ->
    (expect BuilderView).toExtend Ember.Object
