
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory

ScreenFactory = slotcars.factories.ScreenFactory

HomeScreen = (namespace 'slotcars.home').HomeScreen = Ember.Object.extend

  _homeScreenView: null

  appendToApplication: ->
    @_appendScreen()

  _appendScreen: ->
    @_homeScreenView = slotcars.home.views.HomeScreenView.create()
    @_homeScreenView.append()

  destroy: ->
    @_super()
    @_homeScreenView.remove()


ScreenFactory.getInstance().registerScreen 'HomeScreen', HomeScreen