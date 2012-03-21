
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view

TracksController = slotcars.tracks.controllers.TracksController
TracksScreenView = slotcars.tracks.views.TracksScreenView

(namespace 'slotcars.tracks').TracksScreen = Ember.Object.extend

  appendToApplication: ->
    TracksController.create()
    @_tracksScreenView = TracksScreenView.create()

    @_tracksScreenView.append()

  destroy: ->
    @_super()
    @_tracksScreenView.remove()