
#= require slotcars/shared/components/widget
#= require slotcars/account/views/login_view
#= require slotcars/factories/widget_factory

Widget = Slotcars.shared.components.Widget
LoginView = Slotcars.account.views.LoginView
WidgetFactory = Slotcars.factories.WidgetFactory

LoginWidget = (namespace 'Slotcars.account.widgets').LoginWidget = Ember.Object.extend Widget, Ember.Evented,

  init: -> @set 'view', LoginView.create delegate: this

  signUpClicked: -> @fire 'signUpClicked'

WidgetFactory.getInstance().registerWidget 'LoginWidget', LoginWidget