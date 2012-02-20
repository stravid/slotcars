
#= require helpers/namespace
#= require vendor/raphael
#= require game/mediators/track
#= require game/views/track

namespace 'game.controllers'

@game.controllers.GameApplication = Ember.Application.extend
  
  ready: ->
    trackMediator = game.mediators.TrackMediator.create()
    game.views.TrackView.create
      mediator: trackMediator
      paper: Raphael $(@rootElement)[0], 1024, 768