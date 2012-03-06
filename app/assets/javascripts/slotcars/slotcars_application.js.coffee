#= require helpers/namespace
#= require slotcars/route_manager

namespace 'slotcars'

slotcars.SlotcarsApplication = Ember.Application.extend
  screenFactory: null
  currentScreen: null

  init: -> slotcars.RouteManager.create delegate: this

  showBuildScreen: ->
    @_destroyCurrentScreen()
    @currentScreen = @screenFactory.getBuildScreen()
    @currentScreen.appendToApplication()

  showPlayScreen: (trackId) ->
    @_destroyCurrentScreen()
    @currentScreen = @screenFactory.getPlayScreen trackId
    @currentScreen.appendToApplication()

  showTracksScreen: ->
    @_destroyCurrentScreen()
    @currentScreen = @screenFactory.getTracksScreen()
    @currentScreen.appendToApplication()

  showHomeScreen: ->
    @_destroyCurrentScreen()
    @currentScreen = @screenFactory.getHomeScreen()
    @currentScreen.appendToApplication()

  _destroyCurrentScreen: -> @currentScreen.destroy() if @currentScreen