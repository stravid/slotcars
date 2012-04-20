Account.LoginView = Ember.View.extend

  delegate: null
  elementId: 'login-widget-view'
  templateName: 'slotcars_account_templates_login_view_template'

  hasErrors: false

  onLoginButtonClicked: -> (@get 'delegate').loginUserWithCredentials @_getUserCredentials()

  onSignUpButtonClicked: -> (@get 'delegate').switchToSignUp()

  _getUserCredentials: ->
    {
      login: @$('#login-field').val()
      password: @$('#password-field').val()
    }
