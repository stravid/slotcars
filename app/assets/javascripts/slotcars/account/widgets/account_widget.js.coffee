
#= require slotcars/shared/components/widget
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory

Account.AccountWidget = Ember.Object.extend Shared.Widget, Shared.Container,

  init: ->
    @set 'view', Account.AccountWidgetView.create()
    if Shared.User.current?
      @showProfileWidget()
    else
      @showMenuWidget()

  showMenuWidget: ->
    @_removeCurrentContentWidget()
    menuWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'MenuWidget'
    menuWidget.addToContainerAtLocation this, 'content'
    menuWidget.on 'signUpClicked', this, 'showSignUpWidget'
    menuWidget.on 'loginClicked', this, 'showLoginWidget'

  showLoginWidget: ->
    @_removeCurrentContentWidget()
    loginWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'LoginWidget'
    loginWidget.addToContainerAtLocation this, 'content'
    loginWidget.on 'menuClicked', this, 'showMenuWidget'
    loginWidget.on 'signInSuccessful', this, 'showProfileWidget'

  showSignUpWidget: ->
    @_removeCurrentContentWidget()
    signUpWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'userSignedUpSuccessfully', this, 'showProfileWidget'
    signUpWidget.on 'signUpCancelled', this, 'showMenuWidget'

  showProfileWidget: ->
    @_removeCurrentContentWidget()
    profileWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'ProfileWidget'
    profileWidget.addToContainerAtLocation this, 'content'
    profileWidget.on 'currentUserSignedOut', this, 'showMenuWidget'

  _removeCurrentContentWidget: -> (@view.get 'content').destroy() if (@view.get 'content')

Shared.WidgetFactory.getInstance().registerWidget 'AccountWidget', Account.AccountWidget