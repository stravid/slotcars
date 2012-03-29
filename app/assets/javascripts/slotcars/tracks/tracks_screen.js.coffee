
#= require slotcars/tracks/controllers/tracks_controller
#= require slotcars/tracks/views/tracks_screen_view
#= require slotcars/factories/screen_factory

TracksController = slotcars.tracks.controllers.TracksController
TracksScreenView = slotcars.tracks.views.TracksScreenView
ScreenFactory = slotcars.factories.ScreenFactory

TracksScreen = (namespace 'slotcars.tracks').TracksScreen = Ember.Object.extend

  appendToApplication: ->
    @_tracksScreenView = TracksScreenView.create()

    @_tracksScreenView.append()

    TracksController.create
      tracksScreenView: @_tracksScreenView

  destroy: ->
    @_super()
    @_tracksScreenView.remove()


ScreenFactory.get().registerScreen 'TracksScreen', TracksScreen