
#= require slotcars/account/templates/login_view_template

(namespace 'Slotcars.account.views').LoginView = Ember.View.extend

  delegate: null
  elementId: 'login-widget-view'
  templateName: 'slotcars_account_templates_login_view_template'

  hasErrors: false

  onLoginButtonClicked: -> (@get 'delegate').loginUserWithCredentials @_getUserCredentials()

  onSignUpButtonClicked: -> (@get 'delegate').switchToSignUp()

  _getUserCredentials: ->
    {
      email: @$('#email-field').val()
      password: @$('#password-field').val()
    }