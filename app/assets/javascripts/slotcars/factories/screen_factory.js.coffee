
#= require slotcars/build/build_screen
#= require slotcars/play/play_screen
#= require slotcars/tracks/tracks_screen
#= require slotcars/home/home_screen

namespace('slotcars.factories').ScreenFactory = Ember.Object.extend

  getBuildScreen: -> slotcars.build.BuildScreen.create()

  getPlayScreen: (trackId) ->
    (slotcars.play.PlayScreen.create trackId: trackId)

  getTracksScreen: -> slotcars.tracks.TracksScreen.create()

  getHomeScreen: -> slotcars.home.HomeScreen.create()
