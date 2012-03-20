
#= require slotcars/shared/models/track
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/views/draw_view

DrawController = slotcars.build.controllers.DrawController
DrawView = slotcars.build.views.DrawView

(namespace 'slotcars.build').Builder = Ember.Object.extend

  track: null
  drawController: null
  buildScreenView: null

  init: ->
    @track = slotcars.shared.models.Track.createRecord()

    @drawController = DrawController.create
      track: @track

    @_drawView = DrawView.create
      track: @track
      drawController: @drawController

    @buildScreenView.set 'contentView', @_drawView

  destroy: ->
    @_super()
    @drawController.destroy()
    @_drawView.remove()