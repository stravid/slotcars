
#= require embient/ember-data
#= require helpers/math/raphael_path
#= require vendor/raphael
#= require slotcars/shared/models/model_store

RaphaelPath = helpers.math.RaphaelPath
ModelStore = slotcars.shared.models.ModelStore

(namespace 'slotcars.shared.models').Track = DS.Model.extend

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'

  numberOfLaps: 3

  raphaelPath: DS.attr 'string'
  rasterizedPath: DS.attr 'string'

  isRasterizing: false
  rasterizedPath: null

  playRoute: (->
    clientId = @get('clientId')
    "play/#{clientId}"
  ).property 'clientId'

  init: ->
    @_super()
    @set '_raphaelPath', RaphaelPath.create()

  save: ->
    console.log 'SAVED'

    @set 'raphaelPath', @_raphaelPath.get 'path'
    @set 'rasterizedPath', JSON.stringify (@_raphaelPath.get '_rasterizedPath')

    ModelStore.commit()

  didLoad: ->
    # setup the raphaelPath

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
    Ember.run.later (=>
      (@get '_raphaelPath').rasterize
        stepSize: 10
        pointsPerTick: 50
        onProgress: ($.proxy @_onRasterizationProgress, this)
        onFinished: =>
          @set 'isRasterizing', false
          finishCallback() if finishCallback?
    ), 50

  cancelRasterization: ->
    (@get '_raphaelPath').cancelRasterization()
    @set 'isRasterizing', false
    @set 'rasterizedPath', null

  _onRasterizationProgress: (rasterizedLength) ->
    @set 'rasterizedPath', Raphael.getSubpath (@get 'raphaelPath'), 0, rasterizedLength


slotcars.shared.models.Track.reopenClass
  url: 'api/tracks'