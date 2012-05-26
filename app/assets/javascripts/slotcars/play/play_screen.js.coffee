#= require slotcars/shared/mixins/appendable
#= require slotcars/factories/screen_factory

Play.PlayScreen = Ember.Object.extend Shared.Appendable,

  trackId: null
  track: null
  car: null

  _playScreenStateManager: null
  _game: null

  init: ->
    @view = Play.PlayScreenView.create()

    @_playScreenStateManager = Play.PlayScreenStateManager.create delegate: this
    @_playScreenStateManager.send 'load'

  load: ->
    if @trackId?
      @track = Shared.Track.find @trackId
    else
      @track = Shared.Track.findRandom()

    @car = Shared.Car.create track: @track

    if @track.get 'isLoaded'
      @_playScreenStateManager.send 'loaded'
    else
      @track.on 'didLoad', => @_playScreenStateManager.send 'loaded'

  initialize: ->
    @_game = Play.Game.create
      screenView: @view
      track: @track
      car: @car

    @_playScreenNotificationsController = Play.PlayScreenNotificationsController.create
      trackId: @get 'trackId'

    @_playScreenNotificationsView = Play.PlayScreenNotificationsView.create
      controller: @get '_playScreenNotificationsController'

    @_playScreenNotificationsView.append()

    @_playScreenStateManager.send 'initialized'

  play: ->
    @_game.start()

  destroy: ->
    @_super()
    @_game.destroy() if @_game?
    @_playScreenNotificationsController.destroy() if @_playScreenNotificationsController?
    @_playScreenNotificationsView.remove() if @_playScreenNotificationsView?

Shared.ScreenFactory.getInstance().registerScreen 'PlayScreen', Play.PlayScreen
