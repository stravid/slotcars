Account.MenuView = Ember.View.extend

  delegate: null
  elementId: 'menu-widget-view'
  templateName: 'slotcars_account_templates_menu_view_template'
  
  onSignUpButtonClicked: -> (@get 'delegate').switchToSignUp()
  
  onLoginButtonClicked: -> (@get 'delegate').switchToLogin();
