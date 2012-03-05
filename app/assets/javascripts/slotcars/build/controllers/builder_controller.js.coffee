
#= require helpers/namespace
#= require slotcars/shared/models/track_model
#= require slotcars/build/controllers/draw_controller

namespace 'slotcars.build.controllers'

slotcars.build.controllers.BuilderController = Ember.Object.extend

  track: null
  drawController: null
  buildScreenView: null

  init: ->
    @track = slotcars.shared.models.TrackModel.createRecord()

    @drawController = slotcars.build.controllers.DrawController.create
      track: @track

    @drawView = slotcars.build.views.DrawView.create
      track: @track
      drawController: @drawController

    @buildScreenView.set 'contentView', @drawView

  destroy: ->
    @_super()
    @drawController.destroy()
    @drawView.remove()