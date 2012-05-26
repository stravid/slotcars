#= require slotcars/shared/mixins/appendable
#= require slotcars/factories/screen_factory

Tracks.TracksScreen = Ember.Object.extend Shared.Appendable,

  init: ->
    @view = Tracks.TracksScreenView.create()

    Tracks.TracksController.create tracksScreenView: @view


Shared.ScreenFactory.getInstance().registerScreen 'TracksScreen', Tracks.TracksScreen
