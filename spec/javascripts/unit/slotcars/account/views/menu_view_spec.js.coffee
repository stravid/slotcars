describe 'Account.LoginView', ->

  beforeEach ->
    @menuView = Account.MenuView.create()

  it 'should tell delegate about click on sign up button', ->
    delegate = switchToSignUp: sinon.spy()

    @menuView.set 'delegate', delegate
    @menuView.onSignUpButtonClicked()

    (expect delegate.switchToSignUp).toHaveBeenCalled()
  
  it 'should tell delegate about click on login button', ->
    delegate = switchToLogin: sinon.spy()

    @menuView.set 'delegate', delegate
    @menuView.onLoginButtonClicked()

    (expect delegate.switchToLogin).toHaveBeenCalled()