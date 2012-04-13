
#= require slotcars/account/views/login_view

describe 'Slotcars.account.views.LoginView', ->

  LoginView = Slotcars.account.views.LoginView

  beforeEach ->
    @loginView = LoginView.create()

  it 'should use login view template', ->
    (expect @loginView.get 'templateName').toBe 'slotcars_account_templates_login_view_template'

  it 'should tell delegate about click on sign up button', ->
    delegate = userWantsToSignUp: sinon.spy()

    @loginView.set 'delegate', delegate
    @loginView.onSignUpButtonClicked()

    (expect delegate.userWantsToSignUp).toHaveBeenCalled()