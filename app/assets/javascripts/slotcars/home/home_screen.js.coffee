#= require slotcars/factories/screen_factory
#= require slotcars/shared/components/container

Home.HomeScreen = Ember.Object.extend Shared.Container,

  view: null

  init: ->
    @view = Home.HomeScreenView.create()
    accountWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'AccountWidget'
    accountWidget.addToContainerAtLocation this, 'rightColumn'


Shared.ScreenFactory.getInstance().registerScreen 'HomeScreen', Home.HomeScreen
