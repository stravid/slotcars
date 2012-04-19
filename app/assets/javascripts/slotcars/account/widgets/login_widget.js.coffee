
#= require slotcars/shared/components/widget
#= require slotcars/account/views/login_view
#= require slotcars/factories/widget_factory
#= require slotcars/shared/models/user

Widget = Slotcars.shared.components.Widget
LoginView = Slotcars.account.views.LoginView
WidgetFactory = Slotcars.factories.WidgetFactory
User = Slotcars.shared.models.User

LoginWidget = (namespace 'Slotcars.account.widgets').LoginWidget = Ember.Object.extend Widget, Ember.Evented,

  init: -> @set 'view', LoginView.create delegate: this

  loginUserWithCredentials: (credentials) ->
    @view.set 'hasErrors', false
    User.signIn credentials, (=> @tellAboutSuccessfulSignIn()), (=> @showErrorMessageForFailedSignIn())

  tellAboutSuccessfulSignIn: -> @fire 'signInSuccessful'

  showErrorMessageForFailedSignIn: -> @view.set 'hasErrors', true

  switchToSignUp: -> @fire 'signUpClicked'

WidgetFactory.getInstance().registerWidget 'LoginWidget', LoginWidget