
#= require embient/ember-data
#= require helpers/math/raphael_path
#= require vendor/raphael
#= require slotcars/shared/models/model_store

RaphaelPath = helpers.math.RaphaelPath
ModelStore = slotcars.shared.models.ModelStore

Track = (namespace 'slotcars.shared.models').Track = DS.Model.extend

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'

  numberOfLaps: 3

  raphael: DS.attr 'string'
  rasterized: DS.attr 'string'

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
    @set 'raphael', @_raphaelPath.get 'path'
    @set 'rasterized', JSON.stringify (@_raphaelPath.get '_rasterizedPath').asFixedLengthPointArray()

    ModelStore.commit()

  didLoad: ->
    points =
      points: JSON.parse (@get 'rasterized')

    @_raphaelPath.setRaphaelPath @get 'raphael'
    @_raphaelPath.setRasterizedPath points

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

  _onRasterizationProgress: (rasterizedLength) ->
    @set 'rasterizedPath', Raphael.getSubpath (@get 'raphaelPath'), 0, rasterizedLength


Track.reopenClass toString: -> 'slotcars.shared.models.Track'