#= require slotcars/shared/mixins/rasterizable

Shared.Track = DS.Model.extend Shared.Rasterizable,

  _raphaelPath: null
  raphaelPathBinding: '_raphaelPath.path'

  numberOfLaps: 3

  id: DS.attr 'number'
  title: DS.attr 'string'
  username: DS.attr 'string'
  raphael: DS.attr 'string'
  rasterized: DS.attr 'string'

  init: ->
    @_super()
    @set '_raphaelPath', Shared.RaphaelPath.create()

  save: (@_creationCallback) ->
    @set 'raphael', @_raphaelPath.get 'path'
    @set 'rasterized', JSON.stringify (@_raphaelPath.get '_rasterizedPath').asFixedLengthPointArray()

    Shared.ModelStore.commit()

  didCreate: ->
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
    if lap > numberOfLaps then return numberOfLaps else return lap

  setTitle: (title) ->
    if title.length > 0
      (@set 'title', title)
    else
      @setRandomTitle()

  setRandomTitle: ->
    randomTrackTitles = Shared.Track.RANDOM_TRACK_TITLES
    randomIndex = Math.floor (Math.random() * randomTrackTitles.length)
    @set 'title', randomTrackTitles[randomIndex]

Shared.Track.reopenClass

  MINIMUM_TRACK_LENGTH: 400

  # one of these is used if no title provided on publishing
  RANDOM_TRACK_TITLES: [
    'Just Another Awesome One'
    'Anonymous Speedway'
    'Previously Unknown Supertrack'
    'Lost Highway'
  ]

  findRandom: ->
    randomTrack = Shared.ModelStore.materializeRecord Shared.Track, 0

    jQuery.ajax "/api/tracks/random",
      type: "GET"
      dataType: "json"

      success: (response) ->
        trackData = response.track
        trackIds = Shared.ModelStore.load Shared.Track, trackData

        # update the 'clientId' - to ensure that the rest of the tracks data is updated properly
        randomTrack.clientId = trackIds.clientId
        randomTrack.send 'didChangeData'

        randomTrack = Shared.ModelStore.find Shared.Track, trackData.id

    randomTrack
