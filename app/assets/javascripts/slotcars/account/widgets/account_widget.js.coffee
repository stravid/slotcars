
#= require slotcars/shared/components/widget
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory
#= require slotcars/account/views/account_widget_view
#= require slotcars/account/widgets/login_widget
#= require slotcars/account/widgets/sign_up_widget

Widget = Slotcars.shared.components.Widget
Container = Slotcars.shared.components.Container
WidgetFactory = Slotcars.factories.WidgetFactory
AccountWidgetView = Slotcars.account.views.AccountWidgetView

AccountWidget = (namespace 'Slotcars.account.widgets').AccountWidget = Ember.Object.extend Widget, Container,

  init: ->
    @set 'view', AccountWidgetView.create()
    @showLoginWidget()

  showLoginWidget: ->
    loginWidget = WidgetFactory.getInstance().getInstanceOf 'LoginWidget'
    loginWidget.addToContainerAtLocation this, 'content'
    loginWidget.on 'switchToSignUp', this, 'showSignUpWidget'

  showSignUpWidget: ->
    signUpWidget = WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'cancelSignUp', this, 'showLoginWidget'

WidgetFactory.getInstance().registerWidget 'AccountWidget', AccountWidget