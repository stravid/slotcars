Account.LoginView = Ember.View.extend

  delegate: null
  elementId: 'login-widget-view'
  templateName: 'slotcars_account_templates_login_view_template'

  onSignUpButtonClicked: -> (@get 'delegate').switchToSignUp()