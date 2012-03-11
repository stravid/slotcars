
#= require helpers/namespace
#= require slotcars/shared/models/track_model
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/views/draw_view

namespace 'slotcars.build.controllers'

slotcars.build.controllers.BuilderController = Ember.Object.extend

  track: null
  drawController: null
  buildScreenView: null

  init: ->
    @track = slotcars.shared.models.TrackModel.createRecord()

    @drawController = slotcars.build.controllers.DrawController.create
      track: @track

    @_drawView = slotcars.build.views.DrawView.create
      track: @track
      drawController: @drawController

    @buildScreenView.set 'contentView', @_drawView

  destroy: ->
    @_super()
    @drawController.destroy()
    @_drawView.remove()