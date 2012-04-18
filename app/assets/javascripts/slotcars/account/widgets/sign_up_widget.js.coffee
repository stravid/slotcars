
#= require slotcars/shared/components/widget
#= require slotcars/account/views/sign_up_view
#= require slotcars/factories/widget_factory
#= require slotcars/shared/models/user

SignUpView = Slotcars.account.views.SignUpView

SignUpWidget = (namespace 'Slotcars.account.widgets').SignUpWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', SignUpView.create delegate: this

  cancelSignUp: -> @fire 'signUpCancelled'

  signUpUserWithCredentials: (credentials) ->
    Shared.User.signUp credentials
    @fire 'signUpCancelled'

Shared.WidgetFactory.getInstance().registerWidget 'SignUpWidget', SignUpWidget