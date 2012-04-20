Account.SignUpView = Ember.View.extend

  delegate: null
  elementId: 'signup-widget-view'
  templateName: 'slotcars_account_templates_sign_up_view_template'

  validationErrors: null

  onCancelSignUpButtonClicked: -> (@get 'delegate').cancelSignUp()

  onSignUpButtonClicked: -> (@get 'delegate').signUpUserWithCredentials @_getUserCredentials()

  showErrorMessagesForFailedSignUp: (errors) -> @set 'validationErrors', errors

  _getUserCredentials: ->
    {
      username: @$('#username-field').val()
      email: @$('#email-field').val()
      password: @$('#password-field').val()
    }