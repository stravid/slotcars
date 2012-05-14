#= require slotcars/shared/lib/id_observable
#= require slotcars/shared/lib/rasterizable

Shared.Track = DS.Model.extend Shared.IdObservable, Shared.Rasterizable,

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'

  numberOfLaps: 3

  id: DS.attr 'number'
  raphael: DS.attr 'string'

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
  didCreatePersistently: ->
    if @_creationCallback?
      Ember.run.next =>
        @_creationCallback()
        @_creationCallback = null

  didLoad: ->
    points = JSON.parse (@get 'rasterized')

    @_raphaelPath.setRaphaelPath @get 'raphael'
    @_raphaelPath.setRasterizedPath points

  loadHighscores: (callback) ->
    jQuery.ajax "/api/tracks/#{@get 'id'}/highscores",
      type: "GET"
      dataType: 'json'
      success: (response) -> callback response

  addPathPoint: (point) -> (@get '_raphaelPath').addPoint point

  getTotalLength: -> (@get '_raphaelPath').get 'totalLength'

  hasValidTotalLength: -> (@get '_raphaelPath').get('totalLength') > Shared.Track.MINIMUM_TRACK_LENGTH

  getPointAtLength: (length) -> (@get '_raphaelPath').getPointAtLength length

  clearPath: -> (@get '_raphaelPath').clear()

  cleanPath: -> (@get '_raphaelPath').clean minAngle: 10, minLength: 100, maxLength: 400

  getPathPoints: -> (@get '_raphaelPath').getPathPointArray()

  updateRaphaelPath: (points) -> (@get '_raphaelPath').setLinkedPath points

  isLengthAfterFinishLine: (length) -> @getTotalLength() * (@get 'numberOfLaps') < length

  lapForLength: (length) ->
    lap = Math.ceil length / @getTotalLength()
    numberOfLaps = @get 'numberOfLaps'

    # clamp return value to maximum number of laps
    if lap > numberOfLaps then lap = numberOfLaps
    return lap

Shared.Track.reopenClass
  MINIMUM_TRACK_LENGTH: 400
