
#= require helpers/namespace
#= require slotcars/play/views/play_screen_view
#= require slotcars/play/play_screen_state_manager
#= require slotcars/shared/models/track_model
#= require slotcars/play/controllers/play_controller

namespace 'slotcars.play'

TrackModel = slotcars.shared.models.TrackModel
PlayScreenView = slotcars.play.views.PlayScreenView
PlayScreenStateManager = slotcars.play.PlayScreenStateManager
PlayController = slotcars.play.controllers.PlayController

slotcars.play.PlayScreen = Ember.Object.extend

  _playScreenView: null
  _playScreenStateManager: null
  _playController: null

  appendToApplication: ->
    @_playScreenStateManager = PlayScreenStateManager.create delegate: this
    @_playScreenView = PlayScreenView.create()
    @_playScreenView.append()

  destroy: ->
    @_super()
    @_playScreenView.remove()

  load: ->
    @track = TrackModel._create
      path: 'M10,10L20,50'

    @_playScreenStateManager.send 'loaded'

  initialize: ->
    @_playController = PlayController.create
      playScreenView: @_playScreenView