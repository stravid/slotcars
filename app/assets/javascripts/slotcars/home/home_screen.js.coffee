
#= require slotcars/home/views/home_screen_view
#= require slotcars/shared/lib/appendable

Appendable = slotcars.shared.lib.Appendable

(namespace 'slotcars.home').HomeScreen = Ember.Object.extend Appendable,

  appendToApplication: ->
    @_appendScreen()

  _appendScreen: ->
    @view = slotcars.home.views.HomeScreenView.create()
    @appendView()

  destroy: ->
    @_super()
    @removeView()
    