
#= require helpers/namespace
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view

namespace 'slotcars.tracks'

TracksController = slotcars.tracks.controllers.TracksController
TracksScreenView = slotcars.tracks.views.TracksScreenView

slotcars.tracks.TracksScreen = Ember.Object.extend

  appendToApplication: ->
    @_tracksScreenView = TracksScreenView.create()

    @_tracksScreenView.append()

    TracksController.create
      tracksScreenView: @_tracksScreenView

  destroy: ->
    @_super()
    @_tracksScreenView.remove()