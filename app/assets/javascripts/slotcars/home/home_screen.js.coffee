
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable

HomeScreenView = slotcars.home.views.HomeScreenView
ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable

HomeScreen = (namespace 'slotcars.home').HomeScreen = Ember.Object.extend Appendable,

  init: -> @view = HomeScreenView.create()


ScreenFactory.getInstance().registerScreen 'HomeScreen', HomeScreen