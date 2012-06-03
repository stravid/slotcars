
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

    (@view.get 'content').set 'texts', headline: 'Yeah, you\'re back!'

  showSignUpWidget: ->
    @_removeCurrentContentWidget()
    signUpWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'userSignedUpSuccessfully', this, 'showProfileWidget'
    signUpWidget.on 'signUpCancelled', this, 'showMenuWidget'

    (@view.get 'content').set 'texts',
      headline: 'Welcome Racer'
      description: 'Once you signed up, you will be able to build your own tracks
        and save your highscores! You just need to log in the next time you come back.'

  showProfileWidget: ->
    @_removeCurrentContentWidget()
    profileWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'ProfileWidget'
    profileWidget.addToContainerAtLocation this, 'content'
    profileWidget.on 'currentUserSignedOut', this, 'showMenuWidget'

  _removeCurrentContentWidget: -> (@view.get 'content').destroy() if (@view.get 'content')

Shared.WidgetFactory.getInstance().registerWidget 'AccountWidget', Account.AccountWidget
