describe 'Account.LoginView', ->

  beforeEach ->
    @loginView = Account.LoginView.create()

  it 'should tell delegate about click on sign up button', ->
    delegate = switchToSignUp: sinon.spy()

    @loginView.set 'delegate', delegate
    @loginView.onSignUpButtonClicked()

    (expect delegate.switchToSignUp).toHaveBeenCalled()