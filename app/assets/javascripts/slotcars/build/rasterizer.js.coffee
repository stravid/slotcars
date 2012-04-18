
#= require slotcars/build/views/rasterization_view

Build.Rasterizer = Ember.Object.extend
  
  stateManager: null
  track: null
  isRasterizing: false
  buildScreenView: null

  init: ->
    @rasterizationView = Build.RasterizationView.create
      track: @track

    @buildScreenView.set 'contentView', @rasterizationView

  start: ->
    # don't start multiple rasterizations
    return if @get 'isRasterizing'

    @set 'isRasterizing', true
    @track.rasterize => @_finishedRasterization()

  _finishedRasterization: ->
    @set 'isRasterizing', false
    @stateManager.send 'finishedRasterization'

  destroy: ->
    @_super()
    @buildScreenView.set 'contentView', null
    @rasterizationView.destroy()
