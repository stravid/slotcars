#= require helpers/namespace
#= require slotcars/route_manager
#= require helpers/routing/route_local_links

namespace 'slotcars'

slotcars.SlotcarsApplication = Ember.Application.extend
  screenFactory: null
  _currentScreen: null

  ready: ->
    slotcars.routeManager = slotcars.RouteManager.create delegate: this
    helpers.routing.routeLocalLinks slotcars.routeManager

  showBuildScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getBuildScreen()
    @_currentScreen.appendToApplication()

  showPlayScreen: (trackId) ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getPlayScreen trackId
    @_currentScreen.appendToApplication()

  showTracksScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getTracksScreen()
    @_currentScreen.appendToApplication()

  showHomeScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getHomeScreen()
    @_currentScreen.appendToApplication()

  _destroyCurrentScreen: -> @_currentScreen.destroy() if @_currentScreen