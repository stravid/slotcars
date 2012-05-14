
Shared.Rasterizable = Ember.Mixin.create

  rasterized: DS.attr 'string'

  isRasterizing: false
  rasterizedPath: null

  rasterize: (finishCallback) ->
    @set 'isRasterizing', true
    @set 'rasterizedPath', null
    Ember.run.later (=>
      (@get '_raphaelPath').rasterize
        stepSize: 10
        pointsPerTick: 50
        onProgress: ($.proxy @_onRasterizationProgress, this)
        onFinished: =>
          @set 'isRasterizing', false
          finishCallback() if finishCallback?
    ), 50

  _onRasterizationProgress: (rasterizedLength) ->
    @set 'rasterizedPath', Raphael.getSubpath (@get 'raphaelPath'), 0, rasterizedLength