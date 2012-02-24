
#= require helpers/namespace
#= require embient/addons/ember-data
#= require vendor/raphael

namespace 'game.models'

game.models.TrackModel = DS.Model.extend

  path: DS.attr 'string'
  
  totalLength: (Ember.computed ->
    Raphael.getTotalLength @get 'path'
  ).property 'path'

  getPointAtLength: (length) ->
    console.log length, @get 'path'
    Raphael.getPointAtLength (@get 'path'), length