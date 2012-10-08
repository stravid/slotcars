#= require slotcars/factories/screen_factory

Play.PlayScreen = Ember.Object.extend

  view: null
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

    if @track.get 'isLoaded' then @_onTrackLoaded()
    else @track.on 'didLoad', => @_onTrackLoaded()

  _onTrackLoaded: ->
    @_playScreenStateManager.send 'loaded'
    Shared.routeManager.updateLocation 'play/' + @track.get 'id'

  initialize: ->
    @_game = Play.Game.create
      screenView: @view
      track: @track
      car: @car

    @_playScreenNotificationsController = Play.PlayScreenNotificationsController.create
      trackId: @get 'trackId'

    @_playScreenNotificationsView = Play.PlayScreenNotificationsView.create
      controller: @get '_playScreenNotificationsController'

    @_playScreenNotificationsView.appendTo(@view.$())

    @_playScreenStateManager.send 'initialized'

  play: ->
    @_game.start()

  destroy: ->
    @car.destroy()
    @_playScreenStateManager.destroy()
    @_game.destroy() if @_game?
    @_playScreenNotificationsController.destroy() if @_playScreenNotificationsController?
    @_playScreenNotificationsView.destroy() if @_playScreenNotificationsView?
    @_super()

Shared.ScreenFactory.getInstance().registerScreen 'PlayScreen', Play.PlayScreen
