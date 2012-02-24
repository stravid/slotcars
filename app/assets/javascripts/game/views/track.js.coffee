
#= require helpers/namespace

namespace 'game.views'
  
game.views.TrackView = Ember.Object.extend

  init: ->
    @paper.path @mediator.currentTrack.get 'path'