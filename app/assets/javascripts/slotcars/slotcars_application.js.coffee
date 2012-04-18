
#= require slotcars/route_manager
#= require helpers/routing/route_local_links
#= require slotcars/factories/screen_factory

window.SlotcarsApplication = Ember.Application.extend
  _currentScreen: null

  ready: ->
    Shared.routeManager = Shared.RouteManager.create delegate: this
    helpers.routing.routeLocalLinks Shared.routeManager

  showScreen: (screenId, createParamters) ->
    @_destroyCurrentScreen()
    @_currentScreen = Shared.ScreenFactory.getInstance().getInstanceOf screenId, createParamters
    @_currentScreen.append()

  _destroyCurrentScreen: -> @_currentScreen.destroy() if @_currentScreen