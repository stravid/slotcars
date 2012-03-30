
#= require slotcars/route_manager
#= require helpers/routing/route_local_links

(namespace 'slotcars').SlotcarsApplication = Ember.Application.extend
  screenFactory: null
  _currentScreen: null

  ready: ->
    slotcars.routeManager = slotcars.RouteManager.create delegate: this
    helpers.routing.routeLocalLinks slotcars.routeManager

  showBuildScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getBuildScreen()
    @_currentScreen.append()

  showPlayScreen: (trackId) ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getPlayScreen trackId
    @_currentScreen.append()

  showTracksScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getTracksScreen()
    @_currentScreen.append()

  showHomeScreen: ->
    @_destroyCurrentScreen()
    @_currentScreen = @screenFactory.getHomeScreen()
    @_currentScreen.append()

  _destroyCurrentScreen: -> @_currentScreen.destroy() if @_currentScreen