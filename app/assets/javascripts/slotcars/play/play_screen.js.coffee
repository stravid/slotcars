
#= require helpers/namespace
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track_model
#= require slotcars/shared/models/model_store
#= require slotcars/shared/models/car
#= require slotcars/play/game

namespace 'slotcars.play'

ModelStore = slotcars.shared.models.ModelStore
TrackModel = slotcars.shared.models.TrackModel
PlayScreenView = slotcars.play.views.PlayScreenView
PlayScreenStateManager = slotcars.play.PlayScreenStateManager
Car = slotcars.shared.models.Car
Game = slotcars.play.Game

slotcars.play.PlayScreen = Ember.Object.extend

  trackId: null
  _playScreenView: null
  _playScreenStateManager: null
  _game: null

  appendToApplication: ->
    @_playScreenStateManager = PlayScreenStateManager.create delegate: this
    @_playScreenView = PlayScreenView.create()
    @_playScreenView.append()

    @_playScreenStateManager.send 'load'

  destroy: ->
    @_super()
    @_playScreenView.remove()

  load: ->
    @track = ModelStore.findByClientId TrackModel, @trackId

    @car = Car.create
      acceleration: 0.1
      deceleration: 0.2
      crashDeceleration: 0.15
      maxSpeed: 20
      traction: 100

    @_playScreenStateManager.send 'loaded'

  initialize: ->
    @_game = Game.create
      playScreenView: @_playScreenView
      track: @track
      car: @car

    @_playScreenStateManager.send 'initialized'

  play: ->
    @_game.start()