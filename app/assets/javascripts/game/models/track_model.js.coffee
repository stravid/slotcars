
#= require helpers/namespace
#= require embient/ember-data
#= require vendor/raphael

namespace 'game.models'

game.models.TrackModel = DS.Model.extend

  path: DS.attr 'string'
  
  totalLength: (Ember.computed ->
    Raphael.getTotalLength @get 'path'
  ).property 'path'

  getPointAtLength: (length) ->
    Raphael.getPointAtLength (@get 'path'), length