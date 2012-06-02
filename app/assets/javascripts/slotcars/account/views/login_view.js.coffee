Account.LoginView = Ember.View.extend

  delegate: null
  elementId: 'login-widget-view'
  templateName: 'slotcars_account_templates_login_view_template'

  hasErrors: false
  showCancelButton: true

  # form field properties
  login: ''
  password: ''

  submit: (event) ->
    event.preventDefault()
    (@get 'delegate').loginUserWithCredentials { login: @login, password: @password }

  onCancelClicked: -> (@get 'delegate').switchToMenu()
