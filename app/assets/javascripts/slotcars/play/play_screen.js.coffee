
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track
#= require slotcars/shared/models/model_store
#= require slotcars/shared/models/car
#= require slotcars/play/game
#= require slotcars/shared/lib/appendable

ModelStore = slotcars.shared.models.ModelStore
Track = slotcars.shared.models.Track
PlayScreenView = slotcars.play.views.PlayScreenView
PlayScreenStateManager = slotcars.play.PlayScreenStateManager
Car = slotcars.shared.models.Car
Game = slotcars.play.Game
Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.play').PlayScreen = Ember.Object.extend Appendable,

  trackId: null
  _playScreenStateManager: null
  _game: null

  init: ->
    @view = PlayScreenView.create()

    @_playScreenStateManager = PlayScreenStateManager.create delegate: this
    @_playScreenStateManager.send 'load'

  destroy: ->
    @_super()
    @_game.destroy() if @_game?

  load: ->
    @track = ModelStore.find Track, @trackId

    @car = Car.create
      track: @track
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @_playScreenStateManager.send 'loaded'

  initialize: ->
    @_game = Game.create
      playScreenView: @view
      track: @track
      car: @car

    @_playScreenStateManager.send 'initialized'

  play: ->
    @_game.start()
