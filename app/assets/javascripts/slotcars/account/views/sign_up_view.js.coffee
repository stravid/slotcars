Account.SignUpView = Ember.View.extend

  delegate: null
  elementId: 'signup-widget-view'
  templateName: 'slotcars_account_templates_sign_up_view_template'

  validationErrors: null
  showCancelButton: true

  # form field properties
  username: ''
  email: ''
  password: ''

  didInsertElement: -> $('input:first').focus()

  submit: (event) ->
    event.preventDefault()
    (@get 'delegate').signUpUserWithCredentials { username: @username, email: @email, password: @password }

  onCancelSignUpButtonClicked: -> (@get 'delegate').cancelSignUp()

  showErrorMessagesForFailedSignUp: (errors) -> @set 'validationErrors', errors
