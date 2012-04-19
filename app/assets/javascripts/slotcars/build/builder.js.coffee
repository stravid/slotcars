
#= require slotcars/shared/models/track
#= require slotcars/build/controllers/draw_controller
#= require slotcars/build/views/draw_view

Build.Builder = Ember.Object.extend

  stateManager: null
  buildScreenView: null
  track: null
  drawController: null

  init: ->
    @drawController = Build.DrawController.create
      stateManager: @stateManager
      track: @track

    @_drawView = Build.DrawView.create
      track: @track
      drawController: @drawController

    @buildScreenView.set 'contentView', @_drawView

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @drawController.destroy()
    @_drawView.destroy()