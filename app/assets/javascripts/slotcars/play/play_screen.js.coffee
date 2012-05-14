
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

Play.PlayScreen = Ember.Object.extend Shared.Appendable,

  trackId: null
  _playScreenStateManager: null
  _game: null

  init: ->
    @view = Play.PlayScreenView.create()

    @_playScreenStateManager = Play.PlayScreenStateManager.create delegate: this
    @_playScreenStateManager.send 'load'

  destroy: ->
    @_super()
    @_game.destroy() if @_game?
    @_playScreenNotificationsController.destroy() if @_playScreenNotificationsController?
    @_playScreenNotificationsView.remove() if @_playScreenNotificationsView?

  load: ->
    @track = Shared.ModelStore.find Shared.Track, @trackId

    @car = Shared.Car.create
      track: @track
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.3
      maxSpeed: 20
      traction: 100
      offRoadThreshold: 40

    @_playScreenStateManager.send 'loaded'

  initialize: ->
    @_game = Play.Game.create
      playScreenView: @view
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

Shared.ScreenFactory.getInstance().registerScreen 'PlayScreen', Play.PlayScreen
