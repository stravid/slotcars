
#= require helpers/namespace
#= require builder/controllers/builder_controller
#= require builder/views/builder_view

#= require builder/mediators/builder_mediator
#= require shared/mediators/current_track_mediator

namespace 'builder'

builder.BuilderApplication = Ember.View.extend

  elementId: 'builder-application'

  currentTrackMediator: shared.mediators.currentTrackMediator
  builderMediator: builder.mediators.builderMediator

  didInsertElement: ->
    @paper = Raphael @$()[0], 1024, 650

    @builderController = builder.controllers.BuilderController.create()

    @builderView = builder.views.BuilderView.create
      builderController: @builderController
      paper: @paper

    @builderView.appendTo @$()