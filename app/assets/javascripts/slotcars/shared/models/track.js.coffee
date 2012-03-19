
#= require helpers/namespace
#= require embient/ember-data
#= require helpers/math/raphael_path
#= require vendor/raphael

namespace 'slotcars.shared.models'

RaphaelPath = helpers.math.RaphaelPath

slotcars.shared.models.Track = DS.Model.extend

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'
  numberOfLaps: 3

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

  cleanPath: ->
    raphaelPath = (@get '_raphaelPath')
    raphaelPath.clean minAngle: 10, minLength: 100, maxLength: 400

    # defer rasterization for 10 milliseconds since it is time
    # costly and would block other operations
    Ember.run.later (=> raphaelPath.rasterize 5), 10

  isLengthAfterFinishLine: (length) ->
    @getTotalLength() * (@get 'numberOfLaps') < length

  lapForLength: (length) ->
    lap = Math.ceil length / @getTotalLength()
    numberOfLaps = @get 'numberOfLaps'

    # clamp return value to maximum number of laps
    if lap > numberOfLaps then lap = numberOfLaps
    if lap is 0 then return 1 else return lap

slotcars.shared.models.Track.reopenClass
  url: 'api/tracks'