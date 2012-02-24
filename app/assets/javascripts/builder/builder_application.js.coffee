
#= require helpers/namespace
#= require builder/controllers/builder_controller
#= require builder/views/builder_view
#= require builder/mediators/track_mediator

namespace 'builder'

builder.BuilderApplication = Ember.View.extend

  ready: ->
    @trackMediator = builder.mediators.TrackMediator.create()

    @builderController = builder.controllers.BuilderController.create
      mediator: @trackMediator

    @builderView = builder.views.BuilderViews.create
      mediator: @trackMediator
      controller: @trackController