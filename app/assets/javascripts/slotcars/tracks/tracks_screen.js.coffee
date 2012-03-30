
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view
#= require slotcars/shared/lib/appendable

TracksController = slotcars.tracks.controllers.TracksController
TracksScreenView = slotcars.tracks.views.TracksScreenView
Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.tracks').TracksScreen = Ember.Object.extend Appendable,

  init: ->
    @view = TracksScreenView.create()

    TracksController.create
      tracksScreenView: @view
