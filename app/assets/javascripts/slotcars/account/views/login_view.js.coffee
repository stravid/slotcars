
#= require slotcars/account/templates/login_view_template

(namespace 'Slotcars.account.views').LoginView = Ember.View.extend

  delegate: null
  elementId: 'login-widget-view'
  templateName: 'slotcars_account_templates_login_view_template'

  onSignUpButtonClicked: -> (@get 'delegate').signUpClicked()