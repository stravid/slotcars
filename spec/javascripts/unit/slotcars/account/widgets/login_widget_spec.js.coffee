
#= require slotcars/account/widgets/login_widget
#= require slotcars/account/views/login_view
#= require slotcars/factories/widget_factory

LoginWidget = Slotcars.account.widgets.LoginWidget
LoginView = Slotcars.account.views.LoginView
WidgetFactory = Slotcars.factories.WidgetFactory

describe 'Slotcars.shared.widgets.LoginWidget', ->

  beforeEach ->
    @LoginViewMock = mockEmberClass LoginView
    @loginWidget = LoginWidget.create()

  afterEach ->
    @LoginViewMock.restore()

  it 'should be a widget', ->
    (expect @loginWidget).toBeInstanceOf LoginWidget

  it 'should create its login view', ->
    (expect @loginWidget.get 'view').toBe @LoginViewMock

  it 'should register itself at the widget factory', ->
    loginWidget = WidgetFactory.getInstance().getInstanceOf 'LoginWidget'

    (expect loginWidget).toBeInstanceOf LoginWidget

  it 'should provide itself as delegate for its view', ->
    (expect @LoginViewMock.create).toHaveBeenCalledWithAnObjectLike delegate: @loginWidget


  describe 'user wants to sign up', ->

    it 'should fire event when user wants to sign up', ->
      eventHandler = sinon.spy()
      @loginWidget.on 'switchToSignUp', eventHandler

      @loginWidget.userWantsToSignUp()

      (expect eventHandler).toHaveBeenCalled()