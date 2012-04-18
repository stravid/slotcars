
#= require slotcars/shared/components/widget
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory
#= require slotcars/account/views/account_widget_view
#= require slotcars/account/widgets/login_widget
#= require slotcars/account/widgets/sign_up_widget

AccountWidgetView = Slotcars.account.views.AccountWidgetView

AccountWidget = (namespace 'Slotcars.account.widgets').AccountWidget = Ember.Object.extend Shared.Widget, Shared.Container,

  init: ->
    @set 'view', AccountWidgetView.create()
    @showLoginWidget()

  showLoginWidget: ->
    loginWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'LoginWidget'
    loginWidget.addToContainerAtLocation this, 'content'
    loginWidget.on 'signUpClicked', this, 'showSignUpWidget'

  showSignUpWidget: ->
    signUpWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'signUpCancelled', this, 'showLoginWidget'

Shared.WidgetFactory.getInstance().registerWidget 'AccountWidget', AccountWidget