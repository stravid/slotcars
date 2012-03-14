
#= require helpers/namespace
#= require embient/ember-data
#= require slotcars/shared/models/model_store
#= require helpers/math/path
#= require vendor/raphael

namespace 'slotcars.shared.models'

RaphaelPath = helpers.math.RaphaelPath

slotcars.shared.models.Track = DS.Model.extend

  _raphaelPath: null
  _rasterizedPath: null
  _shouldUpdateRasterizedPath: false

  raphaelPathBinding: '_raphaelPath.path'

  init: ->
    @_super()
    @set '_raphaelPath', RaphaelPath.create()

  addPathPoint: (point) -> (@get '_raphaelPath').addPoint point

  getTotalLength: -> (@get '_raphaelPath').getTotalLength()

  getPointAtLength: (length) -> (@get '_raphaelPath').getPointAtLength length

  clearPath: -> (@get '_raphaelPath').clear()

  cleanPath: ->
    (@get '_raphaelPath').clean minAngle: 10, minLength: 100, maxLength: 400

  playRoute: (->
    clientId = @get('clientId')
    "play/#{clientId}"
  ).property 'clientId'

  _updateRasterizedPath: ->
    return unless @_shouldUpdateRasterizedPath

    # defer rasterization since it is time costly and would block other operations
    Ember.run.later (=> @_rasterizeRaphaelPath()), 10

    @_shouldUpdateRasterizedPath = false