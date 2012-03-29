
#= require slotcars/home/views/home_screen_view
#= require slotcars/shared/lib/appendable

HomeScreenView = slotcars.home.views.HomeScreenView
Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.home').HomeScreen = Ember.Object.extend Appendable,

  appendToApplication: ->
    @_appendScreen()

  _appendScreen: ->
    @view = HomeScreenView.create()
    @appendView()
