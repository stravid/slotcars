
#= require slotcars/account/views/login_view

describe 'Slotcars.account.views.LoginView', ->

  LoginView = Slotcars.account.views.LoginView

  beforeEach ->
    @loginView = LoginView.create()

  it 'should tell delegate about click on sign up button', ->
    delegate = switchToSignUp: sinon.spy()

    @loginView.set 'delegate', delegate
    @loginView.onSignUpButtonClicked()

    (expect delegate.switchToSignUp).toHaveBeenCalled()