
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view
#= require slotcars/shared/lib/appendable

TracksController = slotcars.tracks.controllers.TracksController
TracksScreenView = slotcars.tracks.views.TracksScreenView
Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.tracks').TracksScreen = Ember.Object.extend Appendable,

  appendToApplication: ->
    @_appendScreen()

    TracksController.create
      tracksScreenView: @view

  _appendScreen: ->
    @view = TracksScreenView.create()
    @appendView()
