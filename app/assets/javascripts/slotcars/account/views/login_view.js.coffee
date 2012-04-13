
#= require slotcars/account/templates/login_view_template

(namespace 'Slotcars.account.views').LoginView = Ember.View.extend

  delegate: null
  templateName: 'slotcars_account_templates_login_view_template'

  onSignUpButtonClicked: -> (@get 'delegate').userWantsToSignUp()