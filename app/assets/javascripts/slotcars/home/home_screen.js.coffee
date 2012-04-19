
#= require slotcars/home/views/home_screen_view
#= require slotcars/factories/screen_factory
#= require slotcars/shared/lib/appendable
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory
#= require slotcars/account/widgets/account_widget

Home.HomeScreen = Ember.Object.extend Shared.Appendable, Shared.Container,

  init: ->
    @view = Home.HomeScreenView.create()
    accountWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'AccountWidget'
    accountWidget.addToContainerAtLocation this, 'rightColumn'


Shared.ScreenFactory.getInstance().registerScreen 'HomeScreen', Home.HomeScreen