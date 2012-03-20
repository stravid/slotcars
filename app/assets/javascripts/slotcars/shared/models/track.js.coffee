
#= require embient/ember-data
#= require slotcars/shared/models/model_store
#= require helpers/math/raphael_path
#= require vendor/raphael

RaphaelPath = helpers.math.RaphaelPath

namespace('slotcars.shared.models').Track = DS.Model.extend

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'

  numberOfLaps: 3

  isRasterizing: false
  rasterizedPath: null

  playRoute: (->
    clientId = @get('clientId')
    "play/#{clientId}"
  ).property 'clientId'

  init: ->
    @_super()
    @set '_raphaelPath', RaphaelPath.create()

  addPathPoint: (point) -> (@get '_raphaelPath').addPoint point

  getTotalLength: -> (@get '_raphaelPath').get 'totalLength'

  getPointAtLength: (length) -> (@get '_raphaelPath').getPointAtLength length

  clearPath: -> (@get '_raphaelPath').clear()

  cleanPath: -> (@get '_raphaelPath').clean minAngle: 10, minLength: 100, maxLength: 400

  isLengthAfterFinishLine: (length) ->
    @getTotalLength() * (@get 'numberOfLaps') < length

  lapForLength: (length) ->
    lap = Math.ceil length / @getTotalLength()
    numberOfLaps = @get 'numberOfLaps'

    # clamp return value to maximum number of laps
    if lap > numberOfLaps then lap = numberOfLaps
    if lap is 0 then return 1 else return lap

  rasterize: (finishCallback) ->
    @set 'isRasterizing', true
    (@get '_raphaelPath').rasterize
      stepSize: 10
      onProgress: ($.proxy @_onRasterizationProgress, this)
      onFinished: =>
        @set 'isRasterizing', false
        finishCallback() if finishCallback?

  cancelRasterization: ->
    (@get '_raphaelPath').cancelRasterization()
    @set 'isRasterizing', false
    @set 'rasterizedPath', null

  _onRasterizationProgress: (rasterizedLength) ->
    @set 'rasterizedPath', Raphael.getSubpath (@get 'raphaelPath'), 0, rasterizedLength
