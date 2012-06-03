
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.SignUpWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  userToSignUp: null

  init: -> @set 'view', Account.SignUpView.create delegate: this

  cancelSignUp: ->
    @userToSignUp.deleteRecord() if @userToSignUp?
    @fire 'signUpCancelled'

  signUpUserWithCredentials: (credentials) -> @set 'userToSignUp', Shared.User.signUp credentials

  _tellAboutSuccessfulSignUp: (->
    if (@userToSignUp.get 'id')?
      Shared.User.current = @userToSignUp
      @fire 'userSignedUpSuccessfully'
  ).observes 'userToSignUp.id'

  _handleSignUpErrors: (->
    userToSignUp = (@get 'userToSignUp')

    if userToSignUp.get 'hasValidationErrors'
      (@get 'view').showErrorMessagesForFailedSignUp userToSignUp.get 'validationErrors'

  ).observes 'userToSignUp.hasValidationErrors'


Shared.WidgetFactory.getInstance().registerWidget 'SignUpWidget', Account.SignUpWidget
