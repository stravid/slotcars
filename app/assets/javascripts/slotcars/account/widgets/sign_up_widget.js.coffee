
#= require slotcars/shared/components/widget
#= require slotcars/account/views/sign_up_view
#= require slotcars/factories/widget_factory
#= require slotcars/shared/models/user

Widget = Slotcars.shared.components.Widget
SignUpView = Slotcars.account.views.SignUpView
WidgetFactory = Slotcars.factories.WidgetFactory
User = Slotcars.shared.models.User

SignUpWidget = (namespace 'Slotcars.account.widgets').SignUpWidget = Ember.Object.extend Widget, Ember.Evented,

  init: -> @set 'view', SignUpView.create delegate: this

  cancelSignUp: -> @fire 'signUpCancelled'

  signUpUserWithCredentials: (credentials) ->
    User.signUp credentials
    @fire 'signUpCancelled'

WidgetFactory.getInstance().registerWidget 'SignUpWidget', SignUpWidget