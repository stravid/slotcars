
#= require slotcars/route_manager
#= require helpers/routing/route_local_links
#= require slotcars/build/build_screen
#= require slotcars/home/home_screen
#= require slotcars/play/play_screen
#= require slotcars/tracks/tracks_screen
#= require slotcars/factories/screen_factory

ScreenFactory = slotcars.factories.ScreenFactory

(namespace 'slotcars').SlotcarsApplication = Ember.Application.extend
  _currentScreen: null

  ready: ->
    slotcars.routeManager = slotcars.RouteManager.create delegate: this
    helpers.routing.routeLocalLinks slotcars.routeManager

  showBuildScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = ScreenFactory.get().getInstanceOf 'BuildScreen'
    @_currentScreen.appendToApplication()

  showPlayScreen: (trackId) ->
    @_destroyCurrentScreen()
    @_currentScreen = ScreenFactory.get().getInstanceOf 'PlayScreen', trackId: trackId
    @_currentScreen.appendToApplication()

  showTracksScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = ScreenFactory.get().getInstanceOf 'TracksScreen'
    @_currentScreen.appendToApplication()

  showHomeScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = ScreenFactory.get().getInstanceOf 'HomeScreen'
    @_currentScreen.appendToApplication()

  _destroyCurrentScreen: -> @_currentScreen.destroy() if @_currentScreen