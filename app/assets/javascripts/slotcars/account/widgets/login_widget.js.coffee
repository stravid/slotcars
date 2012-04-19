
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.LoginWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.LoginView.create delegate: this

  switchToSignUp: -> @fire 'signUpClicked'

Shared.WidgetFactory.getInstance().registerWidget 'LoginWidget', Account.LoginWidget