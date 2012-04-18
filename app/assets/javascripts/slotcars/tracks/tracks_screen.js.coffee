
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view
#= require slotcars/shared/lib/appendable
#= require slotcars/factories/screen_factory

ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable

Tracks.TracksScreen = Ember.Object.extend Appendable,

  init: ->
    @view = Tracks.TracksScreenView.create()

    Tracks.TracksController.create tracksScreenView: @view


ScreenFactory.getInstance().registerScreen 'TracksScreen', Tracks.TracksScreen
