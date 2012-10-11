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
    @buildScreenView.set 'contentView', null
    @drawController.destroy()
    @_drawView.destroy()
    @_super()
