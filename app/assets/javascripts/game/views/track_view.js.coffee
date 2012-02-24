
#= require helpers/namespace

namespace 'game.views'
  
@game.views.TrackView = Ember.Object.extend

  mediator: null

  init: ->
    @paper.path @mediator.trackPath
    