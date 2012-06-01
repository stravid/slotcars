#= require slotcars/factories/screen_factory

Tracks.TracksScreen = Ember.Object.extend

  view: null

  init: ->
    @view = Tracks.TracksScreenView.create()

    Tracks.TracksController.create tracksScreenView: @view


Shared.ScreenFactory.getInstance().registerScreen 'TracksScreen', Tracks.TracksScreen
