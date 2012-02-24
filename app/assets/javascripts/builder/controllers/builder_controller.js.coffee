#= require helpers/namespace

namespace 'builder.controllers'

builder.controllers.BuilderController = Ember.Object.extend
  mediator: null
  onTouchMouseMove: (point) ->
    @mediator.points.addObject point