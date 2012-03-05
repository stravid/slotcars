
#= require slotcars/build/views/draw_view

describe 'slotcars.build.views.DrawView', ->

  DrawView = slotcars.build.views.DrawView

  it 'should extend Ember.Object', ->
    (expect DrawView).toExtend Ember.Object