
#= require slotcars/shared/components/widget
#= require slotcars/factories/widget_factory

Account.LoginWidget = Ember.Object.extend Shared.Widget, Ember.Evented,

  init: -> @set 'view', Account.LoginView.create delegate: this

  loginUserWithCredentials: (credentials) ->
    @view.set 'hasErrors', false
    Shared.User.signIn credentials, (=> @tellAboutSuccessfulSignIn()), (=> @showErrorMessageForFailedSignIn())

  tellAboutSuccessfulSignIn: -> @fire 'signInSuccessful'

  showErrorMessageForFailedSignIn: -> @view.set 'hasErrors', true

  switchToSignUp: -> @fire 'signUpClicked'

Shared.WidgetFactory.getInstance().registerWidget 'LoginWidget', Account.LoginWidget
