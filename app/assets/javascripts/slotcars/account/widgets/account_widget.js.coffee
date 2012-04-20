
#= require slotcars/shared/components/widget
#= require slotcars/shared/components/container
#= require slotcars/factories/widget_factory

Account.AccountWidget = Ember.Object.extend Shared.Widget, Shared.Container,

  init: ->
    @set 'view', Account.AccountWidgetView.create()
    @showLoginWidget()

  showLoginWidget: ->
    loginWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'LoginWidget'
    loginWidget.addToContainerAtLocation this, 'content'
    loginWidget.on 'signUpClicked', this, 'showSignUpWidget'
    loginWidget.on 'signInSuccessful', this, 'showProfileWidget'

  showSignUpWidget: ->
    signUpWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'SignUpWidget'
    signUpWidget.addToContainerAtLocation this, 'content'
    signUpWidget.on 'userSignedUpSuccessfully', this, 'showProfileWidget'
    signUpWidget.on 'signUpCancelled', this, 'showLoginWidget'

  showProfileWidget: ->
    profileWidget = Shared.WidgetFactory.getInstance().getInstanceOf 'ProfileWidget'
    profileWidget.addToContainerAtLocation this, 'content'
    profileWidget.on 'currentUserSignedOut', this, 'showLoginWidget'

Shared.WidgetFactory.getInstance().registerWidget 'AccountWidget', Account.AccountWidget