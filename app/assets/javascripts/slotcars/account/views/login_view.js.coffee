Account.LoginView = Ember.View.extend

  delegate: null
  elementId: 'login-widget-view'
  templateName: 'slotcars_account_templates_login_view_template'

  hasErrors: false

  onLoginButtonClicked: -> (@get 'delegate').loginUserWithCredentials @_getUserCredentials()
  
  onCancelClicked: -> (@get 'delegate').switchToMenu()

  _getUserCredentials: ->
    {
      login: @$('#login-field').val()
      password: @$('#password-field').val()
    }
