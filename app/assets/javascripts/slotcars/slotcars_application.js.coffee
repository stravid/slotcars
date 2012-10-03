#= require configuration

#= require vendor/raphael
#= require vendor/handlebars
#= require vendor/jquery.animate-enhanced
#= require embient/ember
#= require embient/ember-routemanager
#= require embient/ember-data
#= require embient/ember-layout

#= require namespaces

#= require_tree ../helpers
#= require_tree ../slotcars

window.SlotcarsApplication = Ember.Application.extend
  _currentScreen: null

  ready: ->
    (jQuery document).on 'touchMouseMove', (event) => @onTouchMouseMove(event)

    Shared.routeManager = Shared.RouteManager.create delegate: this
    Shared.routeManager.start()
    Shared.routeLocalLinks Shared.routeManager

  onTouchMouseMove: (event) ->
    event.originalEvent.preventDefault() # prevent scrolling on the iPad

  showScreen: (screenId, createParamters) ->
    @_destroyCurrentScreen()
    @_currentScreen = Shared.ScreenFactory.getInstance().getInstanceOf screenId, createParamters
    @_currentScreen.append()

  _destroyCurrentScreen: -> @_currentScreen.destroy() if @_currentScreen
