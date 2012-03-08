
#= require helpers/namespace
#= require slotcars/home/views/home_screen_view

namespace 'slotcars.home'

slotcars.home.HomeScreen = Ember.Object.extend

  _homeScreenView: null

  appendToApplication: ->
    @_appendScreen()

  _appendScreen: ->
    @_homeScreenView = slotcars.home.views.HomeScreenView.create()
    @_homeScreenView.append()

  destroy: ->
    @_super()
    @_homeScreenView.remove()