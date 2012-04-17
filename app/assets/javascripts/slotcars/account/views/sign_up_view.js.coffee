
#= require slotcars/account/templates/sign_up_view_template

(namespace 'Slotcars.account.views').SignUpView = Ember.View.extend

  delegate: null
  templateName: 'slotcars_account_templates_sign_up_view_template'

  onCancelSignUpButtonClicked: -> (@get 'delegate').userWantsToCancelSignUp()

  onSignUpButtonClicked: -> (@get 'delegate').userWantsToSignUpWithCredentials @_getUserCredentials()

  _getUserCredentials: ->
    {
      username: @$('#username-field').val()
      email: @$('#email-field').val()
      password: @$('#password-field').val()
    }