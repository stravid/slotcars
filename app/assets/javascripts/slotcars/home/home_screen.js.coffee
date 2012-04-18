
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory
#= require slotcars/account/widgets/account_widget

ScreenFactory = slotcars.factories.ScreenFactory
Appendable = slotcars.shared.lib.Appendable
Container = Slotcars.shared.components.Container
WidgetFactory = Slotcars.factories.WidgetFactory

Home.HomeScreen = Ember.Object.extend Appendable, Container,

  init: ->
    @view = Home.HomeScreenView.create()
    accountWidget = WidgetFactory.getInstance().getInstanceOf 'AccountWidget'
    accountWidget.addToContainerAtLocation this, 'rightColumn'


ScreenFactory.getInstance().registerScreen 'HomeScreen', Home.HomeScreen