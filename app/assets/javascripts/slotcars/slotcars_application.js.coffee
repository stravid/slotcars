#= require helpers/namespace
#= require slotcars/route_manager

namespace 'slotcars'

slotcars.SlotcarsApplication = Ember.Application.extend
  screenFactory: null
  _currentScreen: null

  ready: -> slotcars.RouteManager.create delegate: this

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