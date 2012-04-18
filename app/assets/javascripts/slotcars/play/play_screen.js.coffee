
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track
#= require slotcars/shared/models/model_store
#= require slotcars/shared/models/car
#= require slotcars/play/game
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

ScreenFactory = slotcars.factories.ScreenFactory

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

  load: ->
    @track = Shared.ModelStore.find Shared.Track, @trackId

    @car = Shared.Car.create
      track: @track
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @_playScreenStateManager.send 'loaded'

  initialize: ->
    @_game = Play.Game.create
      playScreenView: @view
      track: @track
      car: @car

    @_playScreenStateManager.send 'initialized'

  play: ->
    @_game.start()


ScreenFactory.getInstance().registerScreen 'PlayScreen', Play.PlayScreen
