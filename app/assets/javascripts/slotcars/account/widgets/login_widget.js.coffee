
#= require slotcars/shared/components/widget
#= require slotcars/account/views/login_view
#= require slotcars/factories/widget_factory

LoginView = Slotcars.account.views.LoginView
WidgetFactory = Slotcars.factories.WidgetFactory

LoginWidget = (namespace 'Slotcars.account.widgets').LoginWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', LoginView.create delegate: this

  switchToSignUp: -> @fire 'signUpClicked'

WidgetFactory.getInstance().registerWidget 'LoginWidget', LoginWidget