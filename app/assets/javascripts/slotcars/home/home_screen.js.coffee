
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory
#= require slotcars/account/widgets/account_widget

HomeScreenView = slotcars.home.views.HomeScreenView
ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable
Container = Slotcars.shared.components.Container
WidgetFactory = Slotcars.factories.WidgetFactory

HomeScreen = (namespace 'slotcars.home').HomeScreen = Ember.Object.extend Appendable, Container,

  init: ->
    @view = HomeScreenView.create()
    accountWidget = WidgetFactory.getInstance().getInstanceOf 'AccountWidget'
    accountWidget.addToContainerAtLocation this, 'rightColumn'


ScreenFactory.getInstance().registerScreen 'HomeScreen', HomeScreen