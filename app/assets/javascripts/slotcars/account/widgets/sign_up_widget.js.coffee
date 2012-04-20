
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.SignUpWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.SignUpView.create delegate: this
  user: null

  cancelSignUp: -> @fire 'signUpCancelled'

  signUpUserWithCredentials: (credentials) -> @set 'user', Shared.User.signUp credentials

  userSignedUpSuccessfully: (->
    (@fire 'userSignedUpSuccessfully') if @user.get('id')?
  ).observes 'user.id'

Shared.WidgetFactory.getInstance().registerWidget 'SignUpWidget', Account.SignUpWidget