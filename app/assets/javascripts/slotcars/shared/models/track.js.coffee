#= require slotcars/shared/lib/id_observable

Shared.Track = DS.Model.extend Shared.IdObservable,

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'

  numberOfLaps: 3

  id: DS.attr 'number'
  raphael: DS.attr 'string'
  rasterized: DS.attr 'string'

  isRasterizing: false
  rasterizedPath: null

  init: ->
    @_super()
    @set '_raphaelPath', Shared.RaphaelPath.create()

  save: (@_creationCallback) ->
    @set 'raphael', @_raphaelPath.get 'path'
    @set 'rasterized', JSON.stringify (@_raphaelPath.get '_rasterizedPath').asFixedLengthPointArray()

    Shared.ModelStore.commit()

  # Use the IdObservable mixin to ensure to get notified as soon as
  # the 'id' property is available - ember-data´s 'didCreate' callback is called too early.
  # This is a temporary fix - if ember-data worked as expected, the IdObservable would no longer be needed!
  didCreate: ->
    if @_creationCallback?
      Ember.run.next =>
        @_creationCallback()
        @_creationCallback = null

  didLoad: ->
    points =
      points: JSON.parse (@get 'rasterized')

    @_raphaelPath.setRaphaelPath @get 'raphael'
    @_raphaelPath.setRasterizedPath points

  addPathPoint: (point) -> (@get '_raphaelPath').addPoint point

  getTotalLength: -> (@get '_raphaelPath').get 'totalLength'

  hasValidTotalLength: -> (@get '_raphaelPath').get('totalLength') > Shared.Track.MINIMUM_TRACK_LENGTH

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

Shared.Track.reopenClass
  MINIMUM_TRACK_LENGTH: 400
