#= require slotcars/shared/mixins/appendable
#= require slotcars/factories/screen_factory
#= require slotcars/shared/components/container

Home.HomeScreen = Ember.Object.extend Shared.Appendable, Shared.Container,

  init: ->
    @view = Home.HomeScreenView.create()
    accountWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'AccountWidget'
    accountWidget.addToContainerAtLocation this, 'rightColumn'


Shared.ScreenFactory.getInstance().registerScreen 'HomeScreen', Home.HomeScreen