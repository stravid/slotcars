
#= require slotcars/build/views/rasterization_view

RasterizationView = Slotcars.build.views.RasterizationView

(namespace 'Slotcars.build').Rasterizer = Ember.Object.extend
  
  stateManager: null
  track: null
  isRasterizing: false
  buildScreenView: null

  init: ->
    @rasterizationView = RasterizationView.create
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
