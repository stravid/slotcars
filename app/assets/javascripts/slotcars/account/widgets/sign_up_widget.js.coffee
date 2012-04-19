
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.SignUpWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.SignUpView.create delegate: this

  cancelSignUp: -> @fire 'signUpCancelled'

  signUpUserWithCredentials: (credentials) ->
    Shared.User.signUp credentials
    @fire 'signUpCancelled'

Shared.WidgetFactory.getInstance().registerWidget 'SignUpWidget', Account.SignUpWidget