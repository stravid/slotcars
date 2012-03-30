
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view
#= require slotcars/shared/lib/appendable
#= require slotcars/factories/screen_factory

TracksController = slotcars.tracks.controllers.TracksController
TracksScreenView = slotcars.tracks.views.TracksScreenView
ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable

TracksScreen = (namespace 'slotcars.tracks').TracksScreen = Ember.Object.extend Appendable,

  init: ->
    @view = TracksScreenView.create()
    TracksController.create tracksScreenView: @view


ScreenFactory.getInstance().registerScreen 'TracksScreen', TracksScreen
