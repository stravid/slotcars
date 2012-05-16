
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
    @car = Shared.Car.create track: @track

    @_playScreenStateManager.send 'loaded'

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

Shared.ScreenFactory.getInstance().registerScreen 'PlayScreen', Play.PlayScreen
