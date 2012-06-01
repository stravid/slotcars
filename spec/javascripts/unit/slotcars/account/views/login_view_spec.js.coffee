describe 'Account.LoginView', ->

  beforeEach ->
    @loginView = Account.LoginView.create()

  it 'should tell delegate about click on cancel button', ->
    delegate = switchToMenu: sinon.spy()

    @loginView.set 'delegate', delegate
    @loginView.onCancelClicked()

    (expect delegate.switchToMenu).toHaveBeenCalled()
